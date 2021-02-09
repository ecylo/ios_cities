//
//  City.swift
//  Domain
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

public struct City: Equatable {
	public let name: String
	public let imageUrl: URL?
	public let isFavourite: Bool

	public init(name: String, imageUrl: URL?, isFavourite: Bool) {
		self.name = name
		self.imageUrl = imageUrl
		self.isFavourite = isFavourite
	}
}
