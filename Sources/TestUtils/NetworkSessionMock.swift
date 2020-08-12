//
//  MockURLSession.swift
//  TestUtilsTests
//

@testable import TestUtils
import Foundation

class NetworkSessionMock: NetworkSession {
    
    // MARK: - Mock Response
    /**
        Data expected to be returned in mock response
    */
    var data: Data?
    /**
        URLResponse expected to be returned in mock response.
    */
    private var response: URLResponse? {
        return HTTPURLResponse(url: url!,
                        statusCode: statusCode,
                        httpVersion: nil,
                        headerFields: headerFields)
    }
    /**
        Error expected to be returned in mock response
    */
    var error: Error?
    // Injected response properties
    /**
        Integer status code expected in mock response
    */
    var statusCode = 204
    /**
        Header fields expected in mock response
    */
    var headerFields: [String:String]?
    
    // MARK: - URL or URLRequest used in network call
    var url: URL?
    var request: URLRequest?
    
    // MARK: - Required NetworkSession methods
    /**
     Returns mock response for a GET request to a given URL
     - Parameter url: Endpoint URL
     - Parameter completionHandler: Closure that is called immediately to return the expected `Data`, `URLResponse`, and `Error`
     - Parameter data: Expected `Data` to return
     - Parameter response: Expected `URLResponse` to return
     - Parameter error: Expected `Error` to return
     */
    func loadData(from url: URL, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = url
        completionHandler(data, response, error)
    }
    
    /**
     Returns mock response for the given URLRequest
     
     - Parameter request: The desired URLRequest encapsulating the target `URL`, type of request (GET, PUT, POST), etc.
     - Parameter completionHandler: Closure that is called immediately to return the expected `Data`, `URLRespons`, and `Error`
     - Parameter data: Expected `Data` to return
     - Parameter response: Expected `URLResponse` to return
     - Parameter error: Expected `Error` to return
     */
    func loadData(from request: URLRequest, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.request = request
        completionHandler(data, response, error)
    }
}


