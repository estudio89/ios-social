//
//  SocialAuthListener.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

@objc protocol SocialAuthListener {
    func onSocialLoginButtonClicked(button: UIView)
    func onSocialAuthCanceled(button: UIView, socialAuthIdentifier: String)
    func onSocialAuthFailed(button: UIView, socialAuthIdentifier: String, message: String)
    func onSocialAuthSuccess(button: UIView, socialAuthIdentifier: String, socialAuthToken: String, email: String, name: String, userId: String)
    optional func onSocialLogout(socialAuthIdentifier: String)
}