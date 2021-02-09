//
//  Connector.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

public protocol Connector {
	func connect()
}

public protocol FinishableConnector: Connector {
	func finish()
}

public protocol RootConnector: Connector {
	func showCityDetailsScreen(_ city: City)
}

public protocol CityConnector: Connector {
	func showVisitorsScreen(_ city: CityDetails)
}

public protocol VisitorsConnector: FinishableConnector {}

public struct AlertConfiguration {
	public let title: String
	public let message: String?
	public let actionText: String

	public init(title: String, message: String?, actionText: String) {
		self.title = title
		self.message = message
		self.actionText = actionText
	}
}

public protocol AlertConnector: FinishableConnector {
	func showAlert(_ configuration: AlertConfiguration)
}

public protocol LoadingConnector {
	func showSpinnerView()
	func hideSpinnerView()
}
