//
//  IRequestSender.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import Foundation

protocol IRequestSender {
    func send<Parser>(requestConfig config: RequestConfig<Parser>) async throws -> Parser.Model
}
