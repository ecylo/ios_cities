//
//  CityRepositorySpecs.swift
//  PlatformTests
//
//  Created by Ewelina on 10/02/2021.
//

import XCTest
import Domain
import Foundation
@testable import Platform

class CityRepositorySpecs: XCTestCase {

	var sut: Platform.CityRepository!
	var mockService: MockNetworkService<[CityResponse]>!
	var mockConversionFunction: MockFunction<CityResponse, City>!
	var expectedCity: City!

	override func setUp() {
		super.setUp()

		expectedCity = City(name: "Rzeszów", imageUrl: nil, isFavourite: true)
		mockConversionFunction = MockFunction(output: expectedCity)

		mockService = MockNetworkService()
		sut = CityRepository(
			networkService: mockService,
			cityConversion: mockConversionFunction.functionStub
		)
	}

	func testItGetsCities() {
		mockService.mockResult = .success([CityResponse(name: "", imageUrl: "")])
		sut.getAll { _ in }
		XCTAssertEqual(mockService.invocationsCount, 1)
	}

	func testWhenGettingCitiesSucceedsItReturnsCities() {
		mockService.mockResult = .success([CityResponse(name: "", imageUrl: "")])

		sut.getAll { result in
			switch result {
				case .success(let cities):
					XCTAssertEqual(cities, [self.expectedCity])
				case .failure:
					XCTFail("Should return list of cities")
			}
		}

		XCTAssertEqual(mockConversionFunction.invocationsCount, 1)
	}

	func testWhenGettingCitiesFailsItReturnsError() {
		let expectedError = NSError(domain: "", code: 1, userInfo: nil)
		mockService.mockResult = .failure(expectedError)

		sut.getAll { result in
			switch result {
				case .success:
					XCTFail("Should return an error")
				case .failure(let error):
					XCTAssertEqual(error, Domain.Error.unableToLoadCities)
			}
		}

		XCTAssertEqual(mockConversionFunction.invocationsCount, 0)
	}

	// TODO: Add unit test for the rest of the methods
}
