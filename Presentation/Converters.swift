//
//  Converters.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Domain

public func convert(_ city: City) -> CityPresentationData {
	CityPresentationData(
		name: city.name,
		imageUrl: city.imageUrl,
		indicator: city.isFavourite ? "♥︎" : "♡"
	)
}
