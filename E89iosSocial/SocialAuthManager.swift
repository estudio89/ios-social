//
//  SocialAuthManager.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

class SocialAuthManager: AbstractSocialAuth  {
    private var socialAuths: [SocialAuth] = []
    private var buttonIds: [String:UIView] = [:]
    
    init(listener: SocialAuthListener, buttonIds: [String:UIView]) {
        super.init(listener: listener)
        self.buttonIds = buttonIds
        
        if (buttonIds["facebook"] != nil) {
            self.socialAuths.append(FacebookAuth(listener: listener))
        }
        
        if (buttonIds["google"] != nil) {
            self.socialAuths.append(GoogleAuth(listener: listener))
        }
        
        if (buttonIds["twitter"] != nil) {
            self.socialAuths.append(TwitterAuth(listener: listener))
        }
        
        if (buttonIds["linkedin"] != nil) {
            self.socialAuths.append(LinkedinAuth(listener: listener))
        }
        
        for (_, value) in buttonIds {
            if (value is UIButton) {
                let btn = value as! UIButton
                btn.addTarget(listener, action: Selector("onSocialLoginButtonClicked:"), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    override func setupLogin(loginBtn: UIView? = nil) {
        for socialAuth: SocialAuth in self.socialAuths {
            let buttonView: UIView = self.buttonIds[socialAuth.getSocialAuthIdentifier()]!
            socialAuth.setupLogin(buttonView)
        }
    }
    
    override func initializeSDK() {
        for socialAuth: SocialAuth in self.socialAuths {
            socialAuth.initializeSDK()
        }
    }
    
    override func isLoggedIn() -> Bool {
        for socialAuth: SocialAuth in self.socialAuths {
            if (socialAuth.isLoggedIn()) {
                return true
            }
        }
        return false
    }
    
    func getLoggedInIdentifier() -> String {
        for socialAuth: SocialAuth in self.socialAuths {
            if (socialAuth.isLoggedIn()) {
                socialAuth.getSocialAuthIdentifier()
            }
        }
        return ""
    }
    
    override func logout() {
        for socialAuth: SocialAuth in self.socialAuths {
            socialAuth.logout()
        }
    }
    
    override func getSocialAuthIdentifier() -> String {
        return ""
    }
    
    class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
        
        return true
    }
    
    class func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        // Google
        GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        
        //Linkedin
        if (LISDKCallbackHandler.shouldHandleUrl(url)) {
            LISDKCallbackHandler.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return true
    }
    
    class func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if #available(iOS 9.0, *) {
            // Facebook
            FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                  openURL: url,
                                                                  sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                                  annotation: options[UIApplicationOpenURLOptionsAnnotationKey] as? String)
            
            //Linkedin
            if (LISDKCallbackHandler.shouldHandleUrl(url)) {
                LISDKCallbackHandler.application(app,
                                                 openURL: url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsAnnotationKey] as? String)
            }
            
            // Google
            GIDSignIn.sharedInstance().handleURL(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsAnnotationKey] as? String)
        }
        
        return true
    }
}

class Builder {
    private var listener: SocialAuthListener?
    private var buttonIds: [String:UIView] = [:]
    
    func setListener(listener: SocialAuthListener) -> Builder {
        self.listener = listener
        return self
    }
    
    func setLoginButtonId(socialNetworkIdentifier: String, button: UIView) -> Builder {
        self.buttonIds[socialNetworkIdentifier] = button
        return self
    }
    
    func build() -> SocialAuthManager {
        return SocialAuthManager(listener: self.listener!, buttonIds: self.buttonIds)
    }
}