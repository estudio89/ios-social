//
//  GoogleAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

class GoogleAuth: AbstractSocialAuth, GIDSignInDelegate, GIDSignInUIDelegate {
    private var email: String = ""
    private var name: String = ""
    private var gooToken: String = ""
    private var userId: String = ""
    private var googleLoginButton: UIView?
    
    override func setupLogin(loginBtn: UIView) {
        googleLoginButton = loginBtn
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            self.name = user.profile.name
            self.gooToken = user.authentication.idToken
            self.userId = user.userID
            self.email = user.profile.email
            self.notifyListenerAuthSuccess()
        } else {
            if (listener != nil) {
                listener?.onSocialAuthFailed(googleLoginButton!, socialAuthIdentifier: getSocialAuthIdentifier(), message: error.localizedDescription)
            }
        }
    }
    
    override func initializeSDK() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func notifyListenerAuthSuccess() {
        if (listener != nil) {
            setLoginStatus(true)
            storeAuthData(name, email: email, token: gooToken, userId: userId)
            listener?.onSocialAuthSuccess(googleLoginButton!, socialAuthIdentifier: getSocialAuthIdentifier(), socialAuthToken: gooToken, email: email, name: name, userId: userId)
        }
    }
    
    override func logout() {
        if (!isLoggedIn()) {
            return
        }
        
        GIDSignIn.sharedInstance().signOut()
        
        email = ""
        name = ""
        gooToken = ""
        userId = ""
        
        super.logout()
    }
    
    override func getSocialAuthIdentifier() -> String {
        return "google"
    }
    
    // GIDSignInUIDelegate
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        listener?.onSocialLoginButtonClicked(googleLoginButton!)
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        var topVC: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while (topVC!.presentedViewController != nil) {
            topVC = topVC!.presentedViewController
        }
        
        topVC!.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}