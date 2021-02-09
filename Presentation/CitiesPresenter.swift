//
//  CitiesPresenter.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

public struct CitiesPresenterInput {
	let loadTrigger: ControlEvent<Void>
	let showFavouritesTrigger: ControlEvent<Bool>
	let didSelectCityTrigger: ControlEvent<Int>

	public init(loadTrigger: ControlEvent<Void>,
				showFavouritesTrigger: ControlEvent<Bool>,
				didSelectCityTrigger: ControlEvent<Int>) {
		self.loadTrigger = loadTrigger
		self.showFavouritesTrigger = showFavouritesTrigger
		self.didSelectCityTrigger = didSelectCityTrigger
	}
}

public struct CitiesPresenterOutput {
	public let title: String
	public let cities: BehaviorSubject<[CityPresentationData]>
}

public protocol CitiesPresenting {
	func transform(_ input: CitiesPresenterInput) -> CitiesPresenterOutput
}

final class CitiesPresenter: CitiesPresenting {

	private let connector: RootConnector & AlertConnector & LoadingConnector
	private let getCitiesUseCase: (Bool, @escaping (Result<[City], Domain.Error>) -> Void) -> Void
	private let isLoading: BehaviorSubject<Bool> = BehaviorSubject(false)

	init(connector: RootConnector & AlertConnector & LoadingConnector,
		getCitiesUseCase: @escaping (Bool, @escaping (Result<[City], Domain.Error>) -> Void) -> Void){
		self.connector = connector
		self.getCitiesUseCase = getCitiesUseCase
	}

	func transform(_ input: CitiesPresenterInput) -> CitiesPresenterOutput {
		let cities: BehaviorSubject<[City]> = BehaviorSubject([])

		input.loadTrigger.bind { [weak self] _ in
			let favouriteOnly = input.showFavouritesTrigger.currentValue ?? false
			self?.loadCities(favouriteOnly) { response in
				cities.value = response
			}
		}

		input.showFavouritesTrigger.bind { [weak self] favouritesOnly in
			self?.loadCities(favouritesOnly) { response in
				cities.value = response
			}
		}

		input.didSelectCityTrigger.bind { [weak self] index in
			self?.connector.showCityDetailsScreen(cities.value[index])
		}

		let citiesPresentationData = BehaviorSubject<[CityPresentationData]>([])
		cities.bind { c in
			let presentationData = c.map { convert($0) }
			citiesPresentationData.value = presentationData
		}

		isLoading.bind { [connector] isLoading in
			DispatchQueue.main.async {
				isLoading ? connector.showSpinnerView() : connector.hideSpinnerView()
			}
		}

		return CitiesPresenterOutput(
			title: NSLocalizedString("Cities", comment: ""),
			cities: citiesPresentationData
		)
	}

	private func loadCities(_ favouritesOnly: Bool, completion: @escaping ([City]) -> Void) {
		isLoading.value = true
		getCitiesUseCase(favouritesOnly, { [connector, isLoading] result in
			DispatchQueue.main.async {
				switch result {
					case .success(let cities):
						completion(cities)
					case .failure:
						completion([])
						let alert = AlertConfiguration(
							title: NSLocalizedString("Error", comment: ""),
							message: NSLocalizedString("Unable to load cities. Please try again later.", comment: ""),
							actionText: NSLocalizedString("Ok", comment: "")
						)
						connector.showAlert(alert)
				}
			}
			isLoading.value = false
		})
	}
}
