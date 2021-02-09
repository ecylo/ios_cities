//
//  SpinnerViewController.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit

final class SpinnerViewController: UIViewController {

	lazy var spinner = UIActivityIndicatorView(style: .large)

	override func loadView() {
		super.loadView()
		
		view = UIView()
		view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.startAnimating()
		view.addSubview(spinner)

		spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
}

