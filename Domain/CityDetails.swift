//
//  CityDetails.swift
//  Domain
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

public struct CityDetails {
	public let name: String
	public let imageUrl: URL?
	public let visitors: [String]
	public let averageRating: Int
	public let isFavourite: Bool

	public init(name: String,
				imageUrl: URL?,
				visitors: [String],
				averageRating: Int,
				isFavourite: Bool) {
		self.name = name
		self.imageUrl = imageUrl
		self.visitors = visitors
		self.averageRating = averageRating
		self.isFavourite = isFavourite
	}
}
