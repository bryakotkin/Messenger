//
//  ImagesList.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

struct ImagesList: Codable {
    var imagesURLs: [ImageURL]
    
    enum CodingKeys: String, CodingKey {
        case imagesURLs = "hits"
    }
}

struct ImageURL: Codable {
    var webformatURL: String
}
