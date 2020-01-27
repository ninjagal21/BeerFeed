//
//  Beer.swift
//  BeerFeed
//
//  Created by Alice Fox on 1/26/20.
//  Copyright © 2020 Alice Fox. All rights reserved.
//

import Foundation

struct Beer: Decodable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case tagline
        case description
        case imageUrl = "image_url"
    }
}
