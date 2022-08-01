//
//  Router.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    case getUser
    case login(email: String, password: String)
    case register(email: String, password: String)
    case shows(page: Int)
    case displayShow(id: String)
    case showId(page: Int, id: String)
    case postReview(showId: String, rating: String, comment: String)
    
    var path : String {
        switch self {
        case .getUser:
            return "/users/me"
        case .login:
            return "/users/sign_in"
        case .register:
            return "/users"
        case .shows:
            return "/shows"
        case .displayShow(let id):
            return "/shows/\(id)"
        case .showId(_, let id):
            return "/shows/\(id)/reviews"
        case .postReview:
            return "/reviews"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .login, .register, .postReview:
            return .post
        case .getUser, .shows, .displayShow, .showId:
            return .get
        }
    }
    
    var parameters : [String: String] {
        switch self {
        case .getUser:
            return [:]
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
        case .displayShow:
            return [:]
        case .showId(let page, _):
            return [
                "page": "\(page)",
                "items": "20"
            ]
        case .postReview(let showId, let rating, let comment):
            return [
                "rating": rating,
                "comment": comment,
                "show_id": showId
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
        case .login, .register, .postReview:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getUser, .shows, .displayShow, .showId:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
}
