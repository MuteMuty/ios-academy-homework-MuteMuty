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
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(authInfo) {
            try? shared.set(encoded, key: "authInfo")
        }
    }
        
    static func getAuthInfo() -> AuthInfo? {
        let decoder = PropertyListDecoder()
        if
            let data = try? shared.getData("authInfo"),
            let decodedAuthInfo = try? decoder.decode(AuthInfo.self, from: data)
        {
            return decodedAuthInfo
        }
        return nil
    }
        
    static func removeUserInfo() {
        try? shared.remove("authInfo")
    }
    
}
