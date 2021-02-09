//
//  RootController.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit
import Presentation
import Domain

final class RootConnector: Presentation.RootConnector {

	private let window: UIWindow
	private let navigationController: UINavigationController
	private let presentationProvider: PresentationProvider
	private let factory: CityDependencyFactory & CitiesDependencyFactory

	private var loadingViewController: SpinnerViewController?

	init(window: UIWindow, presentationProvider: PresentationProvider, factory: CityDependencyFactory & CitiesDependencyFactory) {
		self.presentationProvider = presentationProvider
		self.factory = factory
		self.window = window
		navigationController = UINavigationController()
	}

	func connect() {
		let presenter = presentationProvider.makeCitiesPresenter(connector: self, factory: factory)

		let citiesViewController = CitiesViewController(presenter: presenter)

		navigationController.viewControllers = [citiesViewController]
		window.rootViewController =  navigationController
	}

	func showCityDetailsScreen(_ city: City) {
		let presenter = presentationProvider.makeCitiyPresenter(connector: self,
												city: city,
												factory: factory)
		let cityViewController = CityViewController(presenter: presenter)
		navigationController.pushViewController(cityViewController, animated: true)
	}
}

extension RootConnector: CityConnector {

	func showVisitorsScreen(_ city: CityDetails) {
		let presenter = presentationProvider.makeVisitorsPresenter(city: city,
																   connector: self)
		let viewController = UINavigationController(
			rootViewController: VisitorsViewController(presenter: presenter)
		)

		navigationController.present(viewController, animated: true)
	}
}

extension RootConnector: VisitorsConnector {

	func finish() {
		navigationController.dismiss(animated: true)
	}
}

extension RootConnector: AlertConnector {

	func showAlert(_ configuration: AlertConfiguration) {
		let viewController = UIAlertController(
			title: configuration.title,
			message: configuration.message,
			preferredStyle: .alert
		)

		let action = UIAlertAction(title: configuration.actionText, style: .default) { [weak viewController] _ in
			viewController?.dismiss(animated: true)
		}

		viewController.addAction(action)
		navigationController.present(viewController, animated: true)
	}
}

extension RootConnector: LoadingConnector {

	func showSpinnerView() {
		createSpinnerView()
	}

	func hideSpinnerView() {
		guard let child = self.loadingViewController else { return }
		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
	}

	func createSpinnerView() {
		let child = SpinnerViewController()
		navigationController.addChild(child)
		child.view.frame = navigationController.view.frame
		navigationController.view.addSubview(child.view)
		child.didMove(toParent: navigationController)
		loadingViewController = child
	}
}

