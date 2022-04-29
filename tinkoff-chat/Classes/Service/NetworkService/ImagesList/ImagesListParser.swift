//
//  ImagesListParser.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

class ImagesListParser: IParser {
    
    typealias Model = ImagesList
    
    func parse(data: Data) -> Model? {
        return try? JSONDecoder().decode(Model.self, from: data)
    }
}
