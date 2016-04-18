//
//  TwitterAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation
import Fabric

class TwitterAuth: AbstractSocialAuth {
    private var email: String = ""
    private var name: String = ""
    private var twToken: String = ""
    private var userId: String = ""
    private var twitterLoginButton: TwitterButton!
    
    override func setupLogin(loginBtn: UIView) {
        twitterLoginButton = loginBtn as? TwitterButton
        twitterLoginButton.loginMethods = [.WebBased]
        twitterLoginButton.logInCompletion = { session, error in
            if (session != nil) {
                self.twToken = session!.authToken
                self.userId = session!.userID
                self.requestUserData()
            } else {
                self.listener?.onSocialAuthFailed(self.twitterLoginButton, socialAuthIdentifier: self.getSocialAuthIdentifier(), message: error!.localizedDescription)
            }
        }
    }
    
    override func initializeSDK() {
        Fabric.with([Twitter.sharedInstance()])
    }
    
    func requestUserData() {
        let client = TWTRAPIClient.clientWithCurrentUser()
        let request = client.URLRequestWithMethod("GET",
                                                  URL: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                  parameters: ["include_email": "true", "skip_status": "true"],
                                                  error: nil)
        
        client.sendTwitterRequest(request) { response, data, connectionError in
            if (connectionError == nil) {
                let json: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if let dict = json as? [String: AnyObject] {
                    self.name = dict["name"] as? String ?? ""
                    self.email = dict["email"] as? String ?? ""
                }
            }
            self.notifyListenerAuthSuccess()
        }
    }
    
    func notifyListenerAuthSuccess() {
        if (listener != nil) {
            setLoginStatus(true)
            storeAuthData(name, email: email, token: twToken, userId: userId)
            listener?.onSocialAuthSuccess(twitterLoginButton, socialAuthIdentifier: getSocialAuthIdentifier(), socialAuthToken: twToken, email: email, name: name, userId: userId)
        }
    }
    
    override func logout() {
        if (!isLoggedIn()) {
            return
        }
        
        let store = Twitter.sharedInstance().sessionStore
        let userID = store.session()!.userID
        store.logOutUserID(userID)
        
        email = ""
        name = ""
        twToken = ""
        userId = ""
        
        super.logout()
    }
    
    override func getSocialAuthIdentifier() -> String {
        return "twitter"
    }
}