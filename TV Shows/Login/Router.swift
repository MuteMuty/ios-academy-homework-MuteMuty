//
//  Router.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    case login(email: String, password: String)
    case register(email: String, password: String)
    
    var path : String {
        switch self {
        case .login:
            return "/users/sign_in"
        case .register:
            return "/users"
        }
    }
    
    var method : HTTPMethod {
        return .post
    }
    
    var parameters : [String: String] {
        switch self {
        case .login(let email, let password):
            return [
                "email" : email,
                "password" : password
            ]
        case .register(let email, let password):
            return [
                "email" : email,
                "password" : password,
                "password_confirmation" : password
            ]
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: Constants.API.baseURL + path, method: method , headers: HTTPHeaders([:]))
        
        urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
    
}
