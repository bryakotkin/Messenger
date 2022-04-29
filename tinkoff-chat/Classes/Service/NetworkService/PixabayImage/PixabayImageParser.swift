//
//  PixabayImageParse.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation
import UIKit

class PixabayImageParser: IParser {
    typealias Model = UIImage
    
    func parse(data: Data) -> Model? {
        return UIImage(data: data)
    }
}
