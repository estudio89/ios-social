//
//  FacebookAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookAuth: AbstractSocialAuth, FBSDKLoginButtonDelegate {
    private var email: String = ""
    private var name: String = ""
    private var fbToken: String = ""
    private var userId: String = ""
    private var fbLoginButton: FBSDKLoginButton?
    
    private var dataRequestFinished: Bool = false
    
    override func initializeSDK() {
        
    }
    
    override func setupLogin(loginBtn: UIButton) {
        fbLoginButton = loginBtn as? FBSDKLoginButton
        fbLoginButton!.delegate = self
        fbLoginButton!.readPermissions = ["public_profile", "email"]
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onCurrentAccessTokenChanged:",
            name: FBSDKAccessTokenDidChangeNotification,
            object: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            if (listener != nil) {
                listener?.onSocialAuthFailed(loginButton, socialAuthIdentifier: getSocialAuthIdentifier(), message: error.localizedDescription)
            }
        } else {
            if (result.isCancelled) {
                if (listener != nil) {
                    listener?.onSocialAuthCanceled(loginButton, socialAuthIdentifier: getSocialAuthIdentifier())
                }
            } else {
                fbToken = result.token.tokenString
                userId = result.token.userID
                requestUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    func onCurrentAccessTokenChanged(notification: NSNotification) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            logout()
        }
    }
    
    func requestUserData() {
        dataRequestFinished = true
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("----> Error: \(error)")
            } else {
                self.name = result.stringForKey("name")!
                self.email = result.stringForKey("email")!
                self.dataRequestFinished = true
            }
        })
    }
    
    func notifyListenerAuthSuccess() {
        if (dataRequestFinished && listener != nil) {
            setLoginStatus(true)
            storeAuthData(name, email: email, token: fbToken, userId: userId)
            listener?.onSocialAuthSuccess(fbLoginButton!, socialAuthIdentifier: getSocialAuthIdentifier(), socialAuthToken: fbToken, email: email, name: name, userId: userId)
        }
    }
    
    override func logout() {
        if (!isLoggedIn()) {
            return
        }
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        email = ""
        name = ""
        fbToken = ""
        dataRequestFinished = false
        
        super.logout()
    }
    
    override func getSocialAuthIdentifier() -> String {
        return "facebook"
    }
}
