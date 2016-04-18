//
//  AbstractSocialAuth.swift
//  E89iosSocial
//
//  Created by Rodrigo Suhr on 3/17/16.
//  Copyright © 2016 Rodrigo Suhr. All rights reserved.
//

import Foundation

class AbstractSocialAuth: NSObject, SocialAuth {
    static var LOGGED_IN_KEY = "logged_in"
    static var NAME_KEY = "name"
    static var EMAIL_KEY = "email"
    static var TOKEN_KEY = "token"
    static var USER_ID_KEY = "user_id"
    
    internal var listener: SocialAuthListener?
    
    init(listener: SocialAuthListener) {
        self.listener = listener
    }
    
    func setupLogin(loginBtn: UIView) {
    }
    
    func getSocialAuthIdentifier() -> String {
        return ""
    }
    
    func initializeSDK() {
    }
    
    /**
     * This method should be called whenever login is finished successfully, marking the user as logged in.
     * @param loggedIn Bool
     */
    func setLoginStatus(loggedIn: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(loggedIn, forKey: getSocialAuthIdentifier() + "." + AbstractSocialAuth.LOGGED_IN_KEY)
    }
    
    /**
     * Stores the authentication data. This method must be called by child classes right after
     * authentication was successful.
     * @param name String
     * @param email String
     * @param token String
     * @param userId String
     */
    func storeAuthData(name: String, email: String, token: String, userId: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(name, forKey: getSocialAuthIdentifier() + "." + AbstractSocialAuth.NAME_KEY)
        defaults.setValue(email, forKey: getSocialAuthIdentifier() + "." + AbstractSocialAuth.EMAIL_KEY)
        defaults.setValue(token, forKey: getSocialAuthIdentifier() + "." + AbstractSocialAuth.TOKEN_KEY)
        defaults.setValue(userId, forKey: getSocialAuthIdentifier() + "." + AbstractSocialAuth.USER_ID_KEY)
    }
    
    /**
     * Returns an array with the social authentication data.
     *
     * @return social authentication data where data[0] is the user's name, data[1] is the user's
     * email address, data[2] is the token and data[3] is the user's id.
     */
    func getAuthData() -> [String] {
        var authData: [String] = []
        let defaults = NSUserDefaults.standardUserDefaults()
        let name : String? = defaults.stringForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.NAME_KEY)
        let email : String? = defaults.stringForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.EMAIL_KEY)
        let token : String? = defaults.stringForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.TOKEN_KEY)
        let userId : String? = defaults.stringForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.USER_ID_KEY)
        
        if (name != nil && email != nil && token != nil ) {
            authData.append(name!)
            authData.append(email!)
            authData.append(token!)
            authData.append(userId!)
        }
        
        return authData
    }
    
    func clearAuthData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.NAME_KEY)
        defaults.removeObjectForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.EMAIL_KEY)
        defaults.removeObjectForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.TOKEN_KEY)
    }
    
    func logout() {
        setLoginStatus(false)
        clearAuthData()
        self.listener?.onSocialLogout?(getSocialAuthIdentifier())
    }
    
    func isLoggedIn() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(getSocialAuthIdentifier() + "." + AbstractSocialAuth.LOGGED_IN_KEY)
    }
}