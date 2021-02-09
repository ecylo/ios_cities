//
//  CityRepository.swift
//  Platform
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

final class CityRepository: Domain.CityRepository {

	private let networkService: NetworkService
	private let cityConversion: (CityResponse) -> City

	init(networkService: NetworkService,
		 cityConversion: @escaping (CityResponse) -> City) {
		self.networkService = networkService
		self.cityConversion = cityConversion
	}

	func getAll(completion: @escaping (Result<[City], Domain.Error>) -> Void) {
		let path = "64554d7ff1a233d5226b86f259af2735/raw/32f1dade9445298181a1e8685bc72020a40c699d/cities.json"
		networkService
			.get([CityResponse].self, path: path, parameters: nil) { [cityConversion] result in
					switch result {
					case .success(let response):
						let cities = response.map(cityConversion)
						completion(.success(cities))
					case .failure:
						completion(.failure(Domain.Error.unableToLoadCities))
				}
		}
	}

	func getVisitors(_ city: City, completion: @escaping (Result<[String], Domain.Error>) -> Void) {
		let path = "0d088d95e3ccdc132fd99cf169aca8f5/raw/2dc9f447e5bcd5ec7c88c770fc562fa3bafaa8c8/visitors.json"
		networkService
			.get([String].self, path: path, parameters: ["id": city.name]) {  result in
					switch result {
					case .success(let response):
						completion(.success(response))
					case .failure:
						completion(.failure(Domain.Error.unableToLoadCityDetails))
				}
		}
	}

	func getAverageRating(_ city: City, completion: @escaping (Result<Int, Domain.Error>) -> Void) {
		let path = "566c1d5191d54331ca7232714af107bc/raw/d0b3e7b3ccd3fb1dd0074612c037306e819c137a/rating.json"
		networkService
			.get(Int.self, path: path, parameters: ["id": city.name]) {  result in
					switch result {
					case .success(let response):
						completion(.success(response))
					case .failure:
						completion(.failure(Domain.Error.unableToLoadCityDetails))
				}
		}
	}
}
