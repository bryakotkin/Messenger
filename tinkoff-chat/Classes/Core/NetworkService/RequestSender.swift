//
//  RequestSender.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

class RequestSender: IRequestSender {
    
    var session = URLSession.shared
    
    enum NetworkError: Error {
        case badURL
        case badParse
    }
    
    func send<Parser: IParser>(requestConfig config: RequestConfig<Parser>) async throws -> Parser.Model {
        guard let request = config.request.urlRequest else { throw NetworkError.badURL }
        
        let (data, _) = try await session.data(for: request)
        guard let parseData = config.parser.parse(data: data) else { throw NetworkError.badParse }
        
        return parseData
    }
}
