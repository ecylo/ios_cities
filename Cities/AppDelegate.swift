//
//  AppDelegate.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit
import Presentation
import Platform
import Domain

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var connector: Presentation.RootConnector?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)

		start(in: window)

		self.window = window
		window.makeKeyAndVisible()

		return true
	}

	private func start(in window: UIWindow) {
		let environment = Environment.production
		let platformProvider = PlatformProvider()
		let useCaseProvider = Domain.UseCaseProvider(
			cityRepository: platformProvider.makeCityRepository(baseUrl: environment.baseUrl),
			cityStorageRepository: platformProvider.makeCityStorageRepository()
		)

		let dependenciesFactory = DependenciesFactory(useCaseProvider: useCaseProvider)
		connector = RootConnector(
			window: window,
			presentationProvider: PresentationProvider(),
			factory: dependenciesFactory
		)
		connector?.connect()
	}
}
