//
//  CityViewController.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit
import Presentation

final class CityViewController: UIViewController {

	private let presenter: Presentation.CityPresenting

	// TODO: Use RxSwift or similar reactive programming library
	//		 to get rid of the properties below:
	private let loadTrigger = ControlEvent<Void>()
	private let favouritesToggleTrigger = ControlEvent<Void>()
	private let visitorsTrigger = ControlEvent<Void>()

	private lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		return view
	}()

	private lazy var peopleLabel: UILabel = {
		let label = UILabel()
		let gestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(Self.visitorsTriggerAction(_:))
		)
		label.isUserInteractionEnabled = true
		label.addGestureRecognizer(gestureRecognizer)
		return label
	}()

	private lazy var ratingLabel: UILabel = {
		let label = UILabel()
		return label
	}()

	private lazy var favouritesButton: UIButton = {
		let button = UIButton(type: .system)
		button.addTarget(
			self,
			action: #selector(Self.favouritesAction(_:)),
			for: .touchUpInside
		)
		return button
	}()

	init(presenter: Presentation.CityPresenting) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
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

	@objc
	func favouritesAction(_ button: UIButton) {
		favouritesToggleTrigger.event(value: ())
	}

	@objc
	func visitorsTriggerAction(_ gestureRecognizer: UIGestureRecognizer) {
		visitorsTrigger.event(value: ())
	}
}

private typealias UI = CityViewController
private extension UI {

	func configureUI() {
		view.backgroundColor = .white

		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true

		let stackView = UIStackView(
			arrangedSubviews: [imageView, peopleLabel, ratingLabel, favouritesButton]
		)
		stackView.axis = .vertical
		stackView.spacing = 10.0
		stackView.distribution = .fill
		view.addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0).isActive = true
		stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0).isActive = true
		stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10.0).isActive = true
	}
}

private typealias Bindings = CityViewController
private extension Bindings {

	func configureBindings() {
		let input = CityPresenterInput(
			loadTrigger: loadTrigger,
			favouritesToggleTrigger: favouritesToggleTrigger,
			visitorsTrigger: visitorsTrigger
		)

		let output = presenter.transform(input)

		output.presentationData.bindAndReply { [weak self] data in
			DispatchQueue.main.async {
				guard let self = self else { return }

				self.title = data.title
				if let imageUrl = data.imageUrl {
					self.imageView.setImage(from: imageUrl)
				}
				self.peopleLabel.text = data.visitorsCount
				self.ratingLabel.text = data.averageRating
				self.favouritesButton.setTitle(data.favouritesText, for: .normal)
			}
		}
	}
}

