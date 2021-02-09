//
//  VisitorsViewController.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit
import Presentation

final class VisitorsViewController: UITableViewController {

	private enum Configuration {
		static let cellIdentifier = "Cell"
	}

	private let presenter: Presentation.VisitorsPresenting

	// TODO: Use RxSwift or similar reactive programming library
	//		 to get rid of the properties below:
	private let closeTrigger = ControlEvent<Void>()
	private var visitors: [String] = []

	init(presenter: Presentation.VisitorsPresenting) {
		self.presenter = presenter

		super.init(style: .plain)

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: Configuration.cellIdentifier
		)
		tableView.allowsSelection = false
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureUI()
		configureBindings()
	}

	 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return visitors.count
	}

	 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: Configuration.cellIdentifier,
			for: indexPath
		)
		cell.textLabel?.text = visitors[indexPath.row]
		return cell
	}

	@objc
	func closeAction(_ button: UIBarButtonItem) {
		closeTrigger.event(value: ())
	}
}

private typealias UI = VisitorsViewController
private extension UI {

	func configureUI() {
		let closeButton = UIBarButtonItem(
			title: NSLocalizedString("Close", comment: ""), // Button title could be retrieved from the presenter
			style: .plain,
			target: self,
			action: #selector(Self.closeAction(_:))
		)
		navigationItem.leftBarButtonItem = closeButton
	}
}

private typealias Bindings = VisitorsViewController
private extension Bindings {

	func configureBindings() {
		let input = VisitorsPresenterInput(closeTrigger: closeTrigger)
		let output = presenter.transform(input)

		title = output.title
		visitors = output.visitors
		tableView.reloadData()
	}
}

