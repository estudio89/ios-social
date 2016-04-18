//
//  LinkedinAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

class LinkedinAuth: AbstractSocialAuth {
    private var email: String = ""
    private var name: String = ""
    private var lkToken: String = ""
    private var userId: String = ""
    private var lkLoginButton: UIButton?
    
    override func setupLogin(loginBtn: UIView) {
        lkLoginButton = loginBtn as? UIButton
        lkLoginButton!.addTarget(self, action: Selector("loginButton"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func loginButton() {
        LISDKSessionManager.createSessionWithAuth([LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION],
                                                  state:nil,
                                                  showGoToAppStoreDialog:true,
                                                  successBlock: { returnState in
                                                    let session = LISDKSessionManager.sharedInstance().session
                                                    self.lkToken = session.accessToken.accessTokenValue
                                                    self.requestUserData()
            },
                                                  errorBlock: { error in
                                                    self.listener?.onSocialAuthFailed(self.lkLoginButton!, socialAuthIdentifier: self.getSocialAuthIdentifier(), message: error.localizedDescription)
        })
    }
    
    override func initializeSDK() {
        
    }
    
    func requestUserData() {
        LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(first-name,last-name,email-address,id)",
                                                   success: { (response) -> Void in
                                                    let data = response.data.dataUsingEncoding(NSUTF8StringEncoding)
                                                    let json: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                                    if let dict = json as? [String: AnyObject] {
                                                        self.name = "\(dict["firstName"]!) \(dict["lastName"]!)"
                                                        self.email = dict["emailAddress"] as? String ?? ""
                                                        self.userId = dict["id"] as? String ?? ""
                                                    }
                                                    
                                                    self.notifyListenerAuthSuccess()
            },
                                                   error: { (error) -> Void in
        })
    }
    
    func notifyListenerAuthSuccess() {
        if (listener != nil) {
            setLoginStatus(true)
            storeAuthData(name, email: email, token: lkToken, userId: userId)
            listener?.onSocialAuthSuccess(lkLoginButton!, socialAuthIdentifier: getSocialAuthIdentifier(), socialAuthToken: lkToken, email: email, name: name, userId: userId)
        }
    }
    
    override func logout() {
        if (!isLoggedIn()) {
            return
        }
        
        LISDKAPIHelper.sharedInstance().cancelCalls()
        LISDKSessionManager.clearSession()
        
        email = ""
        name = ""
        lkToken = ""
        userId = ""
        
        super.logout()
    }
    
    override func getSocialAuthIdentifier() -> String {
        return "linkedin"
    }
}