//
//  NetworkConfigFactory.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

class NetworkConfigFactory {
    var imagesListConfig: RequestConfig<ImagesListParser> {
        return .init(request: ImagesListRequest(), parser: ImagesListParser())
    }
    
    func getPixabayImageConfig(_ strURL: String) -> RequestConfig<PixabayImageParser> {
        return .init(request: PixabayImageRequest(strURL: strURL), parser: PixabayImageParser())
    }
}
