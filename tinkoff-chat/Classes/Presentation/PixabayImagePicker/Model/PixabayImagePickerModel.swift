//
//  PixabayImagePickerModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation
import UIKit

class PixabayImagePickerModel: IPixabayImagePickerModel {
    
    let requestService: IRequestSender
    let networkFactory: NetworkConfigFactory
    
    init(requestService: IRequestSender, networkFactory: NetworkConfigFactory) {
        self.requestService = requestService
        self.networkFactory = networkFactory
    }
    
    func fetchImagesList() async throws -> ImagesList {
        let config = networkFactory.imagesListConfig
        let list = try await requestService.send(requestConfig: config)
        
        return list
    }
    
    func fetchImage(imageURL: ImageURL) async throws -> UIImage? {
        let config = networkFactory.getPixabayImageConfig(imageURL.webformatURL)
        return try await requestService.send(requestConfig: config)
    }
}
