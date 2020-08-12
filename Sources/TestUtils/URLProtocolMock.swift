//
//  URLProtocolMock.swift
//  
//
//  Created by Michael Chang on 8/12/20.
//  Credits: Adapted from Hacking With Swift (https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way)

import Foundation

class URLProtocolMock: URLProtocol {
    
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: [(data: Data?, response: URLResponse?, error: Error?)]]()

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        defer {
            self.client?.urlProtocolDidFinishLoading(self)
        }
        // if we have a valid URL…
        guard let url = request.url,
            let nextResponse = URLProtocolMock.testURLs[url]?.removeFirst(),
            let urlResponse = nextResponse.response else {
            return
        }
        
        if let error = nextResponse.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else if let data = nextResponse.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        self.client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .allowed)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
