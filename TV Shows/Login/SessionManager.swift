//
//  SessionManager.swift
//  TV Shows
//
//  Created by Infinum on 26.07.2022..
//

import Foundation

final class SessionManager {
    
    static let shared: SessionManager = SessionManager()
    
    var authInfo: AuthInfo?
    
    private init() {}
    
    func storeAuthInfo(headers: [String: String]?) {
        guard let headers = headers else { return }
        let authInfo = try? AuthInfo(headers: headers)
        self.authInfo = authInfo
    }

}
