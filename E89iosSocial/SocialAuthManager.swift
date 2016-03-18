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
    private var buttonIds: [String:UIButton] = [:]
    
    init(listener: SocialAuthListener, buttonIds: [String:UIButton]) {
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
    }
    
    override func initializeSDK() {
        for socialAuth: SocialAuth in self.socialAuths {
            socialAuth.initializeSDK()
        }
    }
    
    override func setupLogin(loginBtn: UIButton) {
        for socialAuth: SocialAuth in self.socialAuths {
            let buttonView: UIButton = self.buttonIds[socialAuth.getSocialAuthIdentifier()]!
            socialAuth.setupLogin(buttonView)
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
    
    override func onActivityResult(requestCode: Int, resultCode: Int) {
        for socialAuth: SocialAuth in self.socialAuths {
            socialAuth.onActivityResult(requestCode, resultCode: resultCode)
        }
    }
    
    override func onDestroy() {
        for socialAuth: SocialAuth in self.socialAuths {
            socialAuth.onDestroy()
        }
    }
}

class Builder {
    private var listener: SocialAuthListener?
    private var buttonIds: [String:UIButton] = [:]
    
    func setListener(listener: SocialAuthListener) -> Builder {
        self.listener = listener
        return self
    }
    
    func setLoginButtonId(socialNetworkIdentifier: String, button: UIButton) -> Builder {
        self.buttonIds[socialNetworkIdentifier] = button
        return self
    }
    
    func build() -> SocialAuthManager {
        return SocialAuthManager(listener: self.listener!, buttonIds: self.buttonIds)
    }
}