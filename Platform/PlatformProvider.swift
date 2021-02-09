//
//  PlatformProvider.swift
//  Platform
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

public final class PlatformProvider {

	public init() {}

	public func makeCityRepository(baseUrl: URL) -> Domain.CityRepository {
		let networkService = URLSessionNetworkService(baseUrl: baseUrl)
		return CityRepository(networkService: networkService, cityConversion: convert(_:))
	}

	public func makeCityStorageRepository() -> Domain.CityStorageRepository {
		return CityStorageRepository(storageService: UserDefaults.standard)
	}
}
