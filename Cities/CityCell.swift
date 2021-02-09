//
//  CityCell.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit
import Presentation

final class CityCell: UITableViewCell {

	private lazy var cityImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()

	private lazy var titleLabel: UILabel = UILabel()
	private lazy var indicatorLabel: UILabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with city: CityPresentationData) {
		titleLabel.text = city.name
		indicatorLabel.text = city.indicator

		cityImageView.image = nil
		if let imageUrl = city.imageUrl {
			cityImageView.setImage(from: imageUrl)
		}
	}
}

private typealias UI = CityCell
extension UI {
	func configureUI() {
		addSubview(cityImageView)

		cityImageView.translatesAutoresizingMaskIntoConstraints = false
		cityImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		cityImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		cityImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		cityImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true

		addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 10.0).isActive = true
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true

		addSubview(indicatorLabel)
		indicatorLabel.translatesAutoresizingMaskIntoConstraints = false
		indicatorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
		indicatorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
	}
}

