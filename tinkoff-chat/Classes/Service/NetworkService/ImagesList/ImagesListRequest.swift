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
        
        let bundle = Bundle.main
        
        guard let pixabayApiKey = bundle.object(forInfoDictionaryKey: EnvConstants.pixabayApiKey.rawValue) as? String,
              let pixabayApiUrl = bundle.object(forInfoDictionaryKey: EnvConstants.pixabayApiUrl.rawValue) as? String else { return nil }
        
        let strUrl = "https://\(pixabayApiUrl)/?key=\(pixabayApiKey)&image_type=\(imageType)&per_page=\(pageSize)&q=\(query)"
        guard let url = URL(string: strUrl) else { return nil }
        let request = URLRequest(url: url)
        
        return request
    }()
}
