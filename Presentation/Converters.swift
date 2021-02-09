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

public func convert(_ city: CityDetails) -> CityDetailsPresentationData {
	let visitorsCountText = NSLocalizedString("Visitors count: \(city.visitors.count) ➡️ℹ️", comment: "")
	let averageRatingText = NSLocalizedString("Average rating: \(city.averageRating)", comment: "")
	let addToFavouritesText = NSLocalizedString("Add to favourites", comment: "")
	let removeFromFavouritesText = NSLocalizedString("Remove from favourites", comment: "")

	return CityDetailsPresentationData(
		title: city.name,
		imageUrl: city.imageUrl,
		visitorsCount: visitorsCountText,
		averageRating: averageRatingText,
		favouritesText: city.isFavourite ? removeFromFavouritesText : addToFavouritesText
	)
}
