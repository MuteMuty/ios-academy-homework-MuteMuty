//
//  ReviewsResponse.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import Foundation

struct ReviewsResponse: Codable {
    let reviews: [Review]
    let meta: Meta
}

struct Review: Codable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}
