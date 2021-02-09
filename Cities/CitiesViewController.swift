//
//  CitiesViewController.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit
import Presentation

final class CitiesViewController: UITableViewController {

	private enum Configuration {
		static let cellIdentifier = "Cell"
	}

	private let presenter: Presentation.CitiesPresenting

	// TODO: Use RxSwift or similar reactive programming library
	//		 to get rid of the properties below:
	private var cities: [CityPresentationData] = []
	private let loadTrigger = ControlEvent<Void>()
	private let favouritesToggleTrigger = ControlEvent<Bool>()
	private let didSelectTrigger = ControlEvent<Int>()

	init(presenter: Presentation.CitiesPresenting) {
		self.presenter = presenter

		super.init(style: .plain)

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(
			CityCell.self,
			forCellReuseIdentifier: Configuration.cellIdentifier
		)
		tableView.rowHeight = 80.0
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureUI()
		configureBindings()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadTrigger.event(value: ())
	}

	 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities.count
	}

	 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CityCell = tableView.dequeueReusableCell(
			withIdentifier: Configuration.cellIdentifier,
			for: indexPath
		) as! CityCell

		let city = cities[indexPath.row]
		cell.update(with: city)

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didSelectTrigger.event(value: indexPath.row)
	}

	@objc
	func switchChanged(_ switchControl: UISwitch) {
		let isOn = switchControl.isOn
		favouritesToggleTrigger.event(value: isOn)
	}
}

private typealias UI = CitiesViewController
private extension UI {

	func configureUI() {
		let switchControl = UISwitch()
		let buttonItem = UIBarButtonItem(customView: switchControl)
		switchControl.addTarget(
			self,
			action: #selector(Self.switchChanged(_:)),
			for: .valueChanged
		)
		navigationItem.rightBarButtonItem = buttonItem
	}
}

private typealias Bindings = CitiesViewController
private extension Bindings {

	func configureBindings() {
		let input = CitiesPresenterInput(
			loadTrigger: loadTrigger,
			showFavouritesTrigger: favouritesToggleTrigger,
			didSelectCityTrigger: didSelectTrigger
		)

		let output = presenter.transform(input)
		title = output.title

		output.cities.bindAndReply { [weak self] cities in
			self?.cities = cities
			self?.tableView.reloadData()
		}
	}
}
