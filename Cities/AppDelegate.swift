//
//  AppDelegate.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.makeKeyAndVisible()

		return true
	}
}

