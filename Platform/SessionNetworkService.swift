//
//  SessionNetworkService.swift
//  Platform
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

protocol NetworkService {
	func get<Response: Decodable>(_ response: Response.Type,
								  path: String,
								  parameters: [String: String]?,
								  callback: @escaping (Result<Response, Error>) -> Void)
}


final class URLSessionNetworkService: NetworkService {

	struct GenericError: Swift.Error {}

	private let baseUrl: URL
	private let session: URLSession
	private let decoder: JSONDecoder

	init(baseUrl: URL) {
		self.baseUrl = baseUrl
		self.session = URLSession.shared
		self.decoder = JSONDecoder()
	}

	func get<Response: Decodable>(_ response: Response.Type,
								  path: String,
								  parameters: [String: String]?,
								  callback: @escaping (Result<Response, Error>) -> Void) {
		let endpointUrl = baseUrl.appendingPathComponent(path)
		let request = URLRequest(url: endpointUrl)

		session
			.dataTask(with: request as URLRequest) { [decoder] data, response, error in
				guard let data = data else {
					callback(.failure(GenericError()))
					return
				}

				do {
					let response = try decoder.decode(Response.self, from: data)
					callback(.success(response))
				}
				catch {
					callback(.failure(error))

				}
			}
			.resume()
	}
}

