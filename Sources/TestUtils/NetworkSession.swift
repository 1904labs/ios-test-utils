//
//  NetworkSession.swift
//  TestUtils
//
//  Created by Michael Chang on 8/12/20.
//  Copyright © 2020 1904labs. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
