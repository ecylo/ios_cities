//
//  VisitorsPresenter.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

public struct VisitorsPresenterInput {
	let closeTrigger: ControlEvent<Void>

	public init(closeTrigger: ControlEvent<Void>) {
		self.closeTrigger = closeTrigger
	}
}

public struct VisitorsPresenterOutput {
	public let title: String
	public let visitors: [String]
}

public protocol VisitorsPresenting {
	func transform(_ input: VisitorsPresenterInput) -> VisitorsPresenterOutput
}

final class VisitorsPresenter: VisitorsPresenting {

	private let connector: VisitorsConnector
	private let city: CityDetails

	init(connector: VisitorsConnector, city: CityDetails){
		self.connector = connector
		self.city = city
	}

	func transform(_ input: VisitorsPresenterInput) -> VisitorsPresenterOutput {
		input.closeTrigger.bind { [weak self] _ in
			self?.connector.finish()
		}

		return VisitorsPresenterOutput(
			title: NSLocalizedString("Visitors", comment: ""),
			visitors: city.visitors)
	}
}
