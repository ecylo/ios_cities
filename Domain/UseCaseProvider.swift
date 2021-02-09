//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

public struct UseCaseProvider {

	private let cityRepository: CityRepository
	private let cityStorageRepository: CityStorageRepository

	public init(cityRepository: CityRepository, cityStorageRepository: CityStorageRepository) {
		self.cityRepository = cityRepository
		self.cityStorageRepository = cityStorageRepository
	}

	public func makeGetCitiesUseCase() -> (Bool, @escaping (Result<[City], Error>) -> Void)  -> () {
		return { [getCities] (favouritesOnly, callback) in
			getCities(favouritesOnly, callback)
		}
	}

	public func makeGetCityDetailsUseCase() -> (City) -> (@escaping (Result<CityDetails, Error>) -> Void) -> () {
		return { city  in
			return { [getCityDetails] callback in
				getCityDetails(city, callback)
			}
		}
	}

	public func makeAddToFavouritesUseCase() -> (City) -> (@escaping (Result<Void, Error>) -> Void) -> () {
		return { city in
			return { [cityStorageRepository] callback in
				cityStorageRepository.add(city, completion: callback)
			}
		}
	}

	public func makeRemoveFromFavouritesUseCase() -> (City) -> (@escaping (Result<Void, Error>) -> Void) -> () {
		return { city in
			return { [cityStorageRepository] callback in
				cityStorageRepository.delete(city, completion: callback)
			}
		}
	}

	private func getCities(favouritesOnly: Bool, callback: @escaping (Result<[City], Error>) -> Void) {
		let updateCitiesFavourteStatus: ([City], [String]) -> [City] = { cities, favouriteCitiesIds in
			var updatedCities = cities.map { city -> City in
				let isFavourite = favouriteCitiesIds.contains(city.name)
				return City(name: city.name, imageUrl: city.imageUrl, isFavourite: isFavourite)
			}
			if favouritesOnly {
				updatedCities = updatedCities.filter { $0.isFavourite == true }
			}

			return updatedCities
		}

		cityRepository.getAll { result in
			switch result {
				case .success(let cities):
					cityStorageRepository.get { favouriteCitiesResult in
						switch favouriteCitiesResult {
							case .success(let cityIds):
								let updatedCities = updateCitiesFavourteStatus(cities, cityIds)
								return callback(.success(updatedCities))
							case .failure:
								return callback(.failure(.unableToLoadCities))
						}
					}
				case .failure:
					return callback(.failure(.unableToLoadCities))
			}
		}
	}

	private func getCityDetails(_ city: City, callback: @escaping (Result<CityDetails, Error>) -> Void) {
		let createDetails: (City, [String], Int) -> CityDetails = { city, visitors, rating in
			return CityDetails(
				name: city.name,
				imageUrl: city.imageUrl,
				visitors: visitors,
				averageRating: rating,
				isFavourite: city.isFavourite
			)
		}

		cityRepository.getVisitors(city) { visitorsResult in
			switch visitorsResult {
				case .success(let visitors):
					cityRepository.getAverageRating(city, completion: { ratingResult in
						switch ratingResult {
							case .success(let rating):
								let details = createDetails(city, visitors, rating)
								callback(.success(details))
							case .failure:
								callback(.failure(.unableToLoadCityDetails))
						}
					})
				case .failure:
					callback(.failure(.unableToLoadCityDetails))
			}
		}
	}
}
