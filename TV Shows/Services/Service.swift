//
//  Service.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import Foundation
import Alamofire

final class Service {
    
    func getUser(completion: @escaping (DataResponse<UserResponse, AFError>) -> Void) {
        
        AF
            .request(Router.getUser)
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
    func register(email: String, password: String, completion: @escaping (DataResponse<UserResponse, AFError>) -> Void) {
        
        AF
            .request(Router.register(email: email, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                SessionManager.shared.storeAuthInfo(dataResponse: dataResponse)
                completion(dataResponse)
            }
    }
    
    func login(email: String, password: String, completion: @escaping (DataResponse<UserResponse, AFError>) -> Void) {
                
        AF
            .request(Router.login(email: email, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                SessionManager.shared.storeAuthInfo(dataResponse: dataResponse)
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
    
    func displayShow(id: String, completion: @escaping (DataResponse<ShowResponse, AFError>) -> Void) {
        
        AF
            .request(Router.displayShow(id: id))
            .validate()
            .responseDecodable(of: ShowResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
    func getShowId(page: Int, id: String, completion: @escaping (DataResponse<ReviewsResponse, AFError>) -> Void) {
        
        AF
            .request(Router.showId(page: page, id: id))
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
    func postReview(showId: String, rating: String, comment: String, completion: @escaping (DataResponse<ReviewResponse, AFError>) -> Void) {
        
        AF
            .request(Router.postReview(showId: showId, rating: rating, comment: comment))
            .validate()
            .responseDecodable(of: ReviewResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
    func storeImage(_ image: UIImage, completion: @escaping (DataResponse<UserResponse, AFError>) -> Void) {
        guard
            let imageData = image.jpegData(compressionQuality: 0.9)
        else { return }

        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )

        AF
            .upload(
                multipartFormData: requestData,
                to: "\(Constants.API.baseURL)/users",
                method: .put,
                headers: HTTPHeaders(SessionManager.shared.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                completion(dataResponse)
            }
    }
    
}
