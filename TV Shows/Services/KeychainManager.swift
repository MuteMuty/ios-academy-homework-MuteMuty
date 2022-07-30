//
//  KeychainManager.swift
//  TV Shows
//
//  Created by Infinum on 29.07.2022..
//

import Foundation
import KeychainAccess

class KeychainManager {
    
    private static let shared = Keychain(server: Constants.API.baseURL, protocolType: .https)
    
    private init() {}
    
    static func addAuthInfo(authInfo: AuthInfo) {
        shared["accessToken"] = authInfo.accessToken
        shared["client"] = authInfo.client
        shared["tokenType"] = authInfo.tokenType
        shared["expiry"] = authInfo.expiry
        shared["uid"] = authInfo.uid
    }
        
    static func getAuthInfo() -> AuthInfo? {
        if
            let accessToken = shared["accessToken"],
            let client = shared["client"],
            let tokenType = shared["tokenType"],
            let expiry = shared["expiry"],
            let uid = shared["uid"]
            {
            let authInfo = AuthInfo(
                accessToken: accessToken,
                client: client,
                tokenType: tokenType,
                expiry: expiry,
                uid: uid)
            return authInfo
        } else {
            return nil
        }
    }
        
    static func removeUserInfo() {
        shared["accessToken"] = nil
        shared["client"] = nil
        shared["tokenType"] = nil
        shared["expiry"] = nil
        shared["uid"] = nil
    }
    
}
