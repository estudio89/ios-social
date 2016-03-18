//
//  SocialAuthListener.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

class SocialAuthListener {
    func onSocialLoginButtonClicked(button: UIButton) {
    }
    
    func onSocialAuthCanceled(button: UIButton, socialAuthIdentifier: String) {
    }
    
    func onSocialAuthFailed(button: UIButton, socialAuthIdentifier: String, message: String) {
    }
    
    func onSocialAuthSuccess(button: UIButton, socialAuthIdentifier: String, socialAuthToken: String, email: String, name: String, userId: String) {
    }
    
    func onSocialLogout(socialAuthIdentifier: String) {
    }
    
}