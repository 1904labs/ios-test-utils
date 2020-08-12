//
//  URLSessionMock.swift
//  
//
//  Created by Michael Chang on 8/12/20.
//

import Foundation

/**
 An example of how to create a mock url session using URLProtocolMock
 */
public var urlSessionMock: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    let session = URLSession(configuration: configuration)
    return session
}
