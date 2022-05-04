//
//  PixabayImageRequest.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

class PixabayImageRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(strURL: String) {
        guard let url = URL(string: strURL) else { return }
        self.urlRequest = URLRequest(url: url)
    }
}
