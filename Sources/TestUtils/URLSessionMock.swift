//
//  File.swift
//  
//
//  Created by Michael Chang on 8/12/20.
//

import Foundation

class URLSessionMock: URLSession {
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        super.init(configuration: configuration)
    }
    
}

