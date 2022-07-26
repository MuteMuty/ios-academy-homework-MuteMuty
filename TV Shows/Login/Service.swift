//
//  Service.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import Foundation
import Alamofire

final class Service {
    
    func register(email: String, password: String, completion: @escaping (DataResponse<UserResponse, AFError>) -> Void) {
        
        AF
            .request(Router.register(email: email, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
    func login(email: String, password: String, completion: @escaping (DataResponse<UserResponse, AFError>) -> Void) {
                
        AF
            .request(Router.login(email: email, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
    func getShows(page: Int, completion: @escaping (DataResponse<ShowsResponse, AFError>) -> Void) {
        
        AF
            .request(Router.shows(page: page))
            .validate()
            .responseDecodable(of: ShowsResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
}
