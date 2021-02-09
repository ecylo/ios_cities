//
//  DependenciesFactory.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain
import Presentation

final class DependenciesFactory {

	let useCaseProvider: Domain.UseCaseProvider

	init(useCaseProvider: UseCaseProvider) {
		self.useCaseProvider = useCaseProvider
	}
}

extension DependenciesFactory: CityDependencyFactory {

	func makeGetCityUseCase(_ city: City) -> (@escaping ResultCompletionHandler<CityDetails>) -> () {
		useCaseProvider.makeGetCityDetailsUseCase()(city)
	}

	func makeAddToFavouritesUseCase(_ city: City) -> (@escaping ResultCompletionHandler<Void>) -> () {
		useCaseProvider.makeAddToFavouritesUseCase()(city)
	}

	func makeRemoveFromFavouritesUseCase(_ city: City) -> (@escaping ResultCompletionHandler<Void>) -> () {
		useCaseProvider.makeRemoveFromFavouritesUseCase()(city)
	}
}

extension DependenciesFactory: CitiesDependencyFactory {

	func makeGetCitiesUseCase() -> (Bool, @escaping (Result<[City], Error>) -> Void) -> Void {
		return useCaseProvider.makeGetCitiesUseCase()
	}
}
