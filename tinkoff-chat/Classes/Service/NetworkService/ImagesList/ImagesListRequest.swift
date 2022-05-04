//
//  ImagesListRequest.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

class ImagesListRequest: IRequest {
    
    var urlRequest: URLRequest? = {
        let imageType = PixabayConstants.imageType.rawValue
        let pageSize = PixabayConstants.pageSize.rawValue
        let query = PixabayConstants.query.rawValue
        
        let strUrl = "https://pixabay.com/api/?key=\(pixabayApiKey)&image_type=\(imageType)&per_page=\(pageSize)&q=\(query)"
        guard let url = URL(string: strUrl) else { return nil }
        let request = URLRequest(url: url)
        
        return request
    }()
}
