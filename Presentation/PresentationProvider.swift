//
//  PresentationProvider.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

public protocol CitiesDependencyFactory {
	func makeGetCitiesUseCase() -> (Bool, @escaping (Result<[City], Error>) -> Void) -> Void
}

public protocol CityDependencyFactory {
	func makeGetCityUseCase(_ city: City) -> (@escaping ResultCompletionHandler<CityDetails>) -> ()
	func makeAddToFavouritesUseCase(_ city: City) -> (@escaping ResultCompletionHandler<Void>) -> ()
	func makeRemoveFromFavouritesUseCase(_ city: City) -> (@escaping ResultCompletionHandler<Void>) -> ()
}

public final class PresentationProvider {

	public init() {}

	public func makeCitiesPresenter(connector: RootConnector & AlertConnector & LoadingConnector,
									factory: CitiesDependencyFactory) -> CitiesPresenting {
		return CitiesPresenter(
			connector: connector,
			getCitiesUseCase: factory.makeGetCitiesUseCase()
		)
	}

	public func makeCitiyPresenter(connector: CityConnector & AlertConnector & LoadingConnector,
								   city: City,
								   factory: CityDependencyFactory) -> CityPresenting {
		return CityPresenter(
			city,
			connector: connector,
			getCityDetailsUseCase: factory.makeGetCityUseCase(city),
			addToFavouritesUseCase: factory.makeAddToFavouritesUseCase(city),
			removeFromFavouritesUseCase: factory.makeRemoveFromFavouritesUseCase(city)
		)
	}

	public func makeVisitorsPresenter(city: CityDetails, connector: VisitorsConnector) -> VisitorsPresenting {
		return VisitorsPresenter(connector: connector, city: city)
	}
}
