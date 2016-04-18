//
//  SocialAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

protocol SocialAuth {
    func setupLogin(loginBtn: UIView)
    func initializeSDK()
    func getSocialAuthIdentifier() -> String
    func isLoggedIn() -> Bool
    func logout()
}