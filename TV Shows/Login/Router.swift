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
    case shows(page: Int)
    case showId(page: Int, id: String)
    
    var path : String {
        switch self {
        case .login:
            return "/users/sign_in"
        case .register:
            return "/users"
        case .shows:
            return "/shows"
        case .showId(_, let id):
            return "/shows/\(id)/reviews"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        case .shows, .showId:
            return .get
        }
    }
    
    var parameters : [String: String] {
        switch self {
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .register(let email, let password):
            return [
                "email": email,
                "password": password,
                "password_confirmation": password
            ]
        case .shows(let page):
            return [
                "page": "\(page)",
                "items": "20"
            ]
        case .showId(let page, _):
            return [
                "page": "\(page)",
                "items": "20"
            ]
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        let headers = SessionManager.shared.authInfo?.headers ?? [:]
        var urlRequest = try URLRequest(
            url: Constants.API.baseURL + path,
            method: method,
            headers: HTTPHeaders(headers)
        )
        
        switch self {
        case .login, .register:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .shows, .showId:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
}
