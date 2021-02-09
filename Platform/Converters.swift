//
//  Converters.swift
//  Platform
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

func convert(_ response: CityResponse) -> City {
	let url = URL(string: response.imageUrl)
	return City(name: response.name, imageUrl: url, isFavourite: false)
}
