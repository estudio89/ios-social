//
//  FacebookAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

class FacebookAuth: AbstractSocialAuth, FacebookButtonDelegate {
    private var email: String = ""
    private var name: String = ""
    private var fbToken: String = ""
    private var userId: String = ""
    private var fbLoginButton: FacebookButton?
    
    private var dataRequestFinished: Bool = false
    
    override func setupLogin(loginBtn: UIView) {
        fbLoginButton = loginBtn as? FacebookButton
        fbLoginButton!.delegate = self
        fbLoginButton!.readPermissions = ["public_profile", "email"]
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onCurrentAccessTokenChanged:",
            name: FBSDKAccessTokenDidChangeNotification,
            object: nil)
    }
    
    override func initializeSDK() {
    }
    
    func loginButton(loginButton: FacebookButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            self.onFailed(error)
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
                self.onFailed(error)
            } else {
                self.name = result["name"] as! String
                self.email = result["email"] as! String
                self.dataRequestFinished = true
                self.notifyListenerAuthSuccess()
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
    
    func onFailed(error: NSError) {
        if (listener != nil) {
            listener?.onSocialAuthFailed((fbLoginButton as! UIButton), socialAuthIdentifier: getSocialAuthIdentifier(), message: error.localizedDescription)
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
        userId = ""
        dataRequestFinished = false
        
        super.logout()
    }
    
    override func getSocialAuthIdentifier() -> String {
        return "facebook"
    }
}
