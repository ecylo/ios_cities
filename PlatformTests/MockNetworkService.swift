//
//  MockNetworkService.swift
//  PlatformTests
//
//  Created by Ewelina on 10/02/2021.
//

import Foundation
@testable import Platform

class MockNetworkService<Response>: Platform.NetworkService {

	var mockResult: Result<Response, Error>!
	var invocationsCount: Int = 0
	func get<Response: Decodable>(_ response: Response.Type,
								  path: String,
								  parameters: [String: String]?,
								  callback: @escaping (Result<Response, Error>) -> Void) {
		invocationsCount += 1
		callback(mockResult as! Result<Response, Error>)
	}
}
