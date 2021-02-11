//
//  MockConnector.swift
//  PresentationTests
//
//  Created by Ewelina on 11/02/2021.
//

import Presentation
import Domain

final class MockConnector: RootConnector & LoadingConnector & AlertConnector {

	var showAlertInvocationsCount: Int = 0
	var didShowAlertCallback: (() -> Void)?
	var isLoadingToggleStatuses: [Bool] = []
	var didShowDetailsCallback: ((City) -> Void)?

	func connect() {}

	func showCityDetailsScreen(_ city: City) {
		didShowDetailsCallback?(city)
	}

	func showSpinnerView() {
		isLoadingToggleStatuses.append(true)
	}

	func hideSpinnerView() {
		isLoadingToggleStatuses.append(false)
	}

	func showAlert(_ configuration: AlertConfiguration) {
		showAlertInvocationsCount += 1
		didShowAlertCallback?()
	}

	func finish() {}
}
