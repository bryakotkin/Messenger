//
//  RequestConfig.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import Foundation

struct RequestConfig<Parser: IParser> {
    var request: IRequest
    var parser: Parser
}
