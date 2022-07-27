//
//  SessionManager.swift
//  TV Shows
//
//  Created by Infinum on 26.07.2022..
//

import Foundation
import Alamofire

final class SessionManager {
    
    static let shared: SessionManager = SessionManager()
    
    var authInfo: AuthInfo?
    
    private init() {}
    
    func storeAuthInfo(dataResponse: DataResponse<UserResponse, AFError>?) {
        let headers = dataResponse?.response?.headers.dictionary
        guard let headers = headers else { return }
        let authInfo = try? AuthInfo(headers: headers)
        self.authInfo = authInfo
    }

}
