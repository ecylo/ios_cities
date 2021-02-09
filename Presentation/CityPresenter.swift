//
//  CityPresenter.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

public struct CityPresenterInput {
	let loadTrigger: ControlEvent<Void>
	let favouritesToggleTrigger: ControlEvent<Void>
	let visitorsTrigger: ControlEvent<Void>

	public init(loadTrigger: ControlEvent<Void>,
				favouritesToggleTrigger: ControlEvent<Void>,
				visitorsTrigger: ControlEvent<Void>) {
		self.loadTrigger = loadTrigger
		self.favouritesToggleTrigger = favouritesToggleTrigger
		self.visitorsTrigger = visitorsTrigger
	}
}

public struct CityPresenterOutput {
	public let presentationData: BehaviorSubject<CityDetailsPresentationData>
}

public protocol CityPresenting {
	func transform(_ input: CityPresenterInput) -> CityPresenterOutput
}

public typealias ResultCompletionHandler<ResultType> = ((Result<ResultType, Domain.Error>) -> Void)

final class CityPresenter: Presentation.CityPresenting {

	private let connector: CityConnector & AlertConnector & LoadingConnector
	private let getCityDetailsUseCase: (@escaping ResultCompletionHandler<CityDetails>) -> ()
	private let addToFavouritesUseCase: (@escaping ResultCompletionHandler<Void>) -> ()
	private let removeFromFavouritesUseCase: (@escaping ResultCompletionHandler<Void>) -> ()
	private let conversion: (CityDetails) -> CityDetailsPresentationData
	private let presentationData: BehaviorSubject<CityDetailsPresentationData>
	private let isLoading = BehaviorSubject<Bool>(false)
	private let cityDetails: BehaviorSubject<CityDetails?> = BehaviorSubject(nil)

	init(_ city: City,
		 connector: CityConnector & AlertConnector & LoadingConnector,
		 getCityDetailsUseCase: @escaping (@escaping ResultCompletionHandler<CityDetails>) -> (),
		 addToFavouritesUseCase: @escaping (@escaping ResultCompletionHandler<Void>) -> (),
		 removeFromFavouritesUseCase: @escaping (@escaping ResultCompletionHandler<Void>) -> (),
		 conversion: @escaping (CityDetails) -> CityDetailsPresentationData = convert(_:)) {
		self.connector = connector
		self.getCityDetailsUseCase = getCityDetailsUseCase
		self.addToFavouritesUseCase = addToFavouritesUseCase
		self.removeFromFavouritesUseCase = removeFromFavouritesUseCase
		self.conversion = conversion
		let initialPresentationData = CityDetailsPresentationData(
			title: city.name,
			imageUrl: city.imageUrl,
			visitorsCount: "",
			averageRating: "",
			favouritesText: ""
		)
		presentationData = BehaviorSubject(initialPresentationData)
	}

	func transform(_ input: CityPresenterInput) -> CityPresenterOutput {
		input.loadTrigger.bind { [weak self] _ in
			self?.load()
		}

		input.favouritesToggleTrigger.bind { [add, remove, cityDetails] trigger in
			guard let details = cityDetails.value else { return }

			if details.isFavourite {
				remove()
			} else {
				add()
			}
		}

		input.visitorsTrigger.bind { [weak self] _ in
			self?.connector.showVisitorsScreen(self!.cityDetails.value!)
		}

		isLoading.bind { [connector] isLoading in
			DispatchQueue.main.async {
				isLoading ? connector.showSpinnerView() : connector.hideSpinnerView()
			}
		}

		return CityPresenterOutput(
			presentationData: presentationData
		)
	}

	private func load() {
		isLoading.value = true
		getCityDetailsUseCase { [updateCity, isLoading, showAlert] result in
			switch result {
				case .success(let details):
					updateCity(details)
				case .failure:
					showAlert(NSLocalizedString("Unable to load city details.", comment: ""))
			}
			isLoading.value = false
		}
	}

	private func add() {
		isLoading.value = true
		addToFavouritesUseCase { [updateCityFavouriteStatus, isLoading, showAlert] result in
			switch result {
				case .success:
					updateCityFavouriteStatus(true)
				case .failure:
					showAlert(
						NSLocalizedString("Cannot add to the favourites.", comment: "")
					)
			}
			isLoading.value = false
		}
	}

	private func remove() {
		isLoading.value = true
		removeFromFavouritesUseCase { [updateCityFavouriteStatus, isLoading, showAlert] result in
			switch result {
				case .success:
					updateCityFavouriteStatus(false)
				case .failure:
					showAlert(
						NSLocalizedString("Cannot remove from the favourites.", comment: "")
					)
			}
			isLoading.value = false
		}
	}

	private func updateCityFavouriteStatus(isFavourite: Bool) {
		guard let cityDetailsValue = cityDetails.value else { return }
		let updatedCityDetails = CityDetails(
			name: cityDetailsValue.name,
			imageUrl: cityDetailsValue.imageUrl,
			visitors: cityDetailsValue.visitors,
			averageRating: cityDetailsValue.averageRating,
			isFavourite: isFavourite
		)
		updateCity(updatedCityDetails)
	}

	private func updateCity(_ updatedCityDetails: CityDetails) {
		cityDetails.value = updatedCityDetails
		presentationData.value = conversion(updatedCityDetails)
	}

	private func showAlert(message: String) {
		let alert = AlertConfiguration(
			title: NSLocalizedString("Error", comment: ""),
			message: message,
			actionText: NSLocalizedString("Ok", comment: "")
		)
		connector.showAlert(alert)
	}
}
