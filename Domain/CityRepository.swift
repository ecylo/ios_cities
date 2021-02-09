//
//  CityRepository.swift
//  Domain
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

import Foundation

public protocol CityRepository {
	func getAll(completion: @escaping (Result<[City], Domain.Error>) -> Void)
	func getVisitors(_ city: City, completion: @escaping (Result<[String], Domain.Error>) -> Void)
	func getAverageRating(_ city: City, completion: @escaping (Result<Int, Domain.Error>) -> Void)
}
