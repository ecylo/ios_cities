//
//  CitiesPresenterSpecs.swift
//  PresentationTests
//
//  Created by Ewelina on 11/02/2021.
//

import XCTest
import Domain
@testable import Presentation

class CitiesPresenterSpecs: XCTestCase {

	var sut: CitiesPresenter!
	var mockConnector: MockConnector!

	typealias UseCaseInput = (Bool, (Result<[City], Error>) -> Void)
	var mockGetCitiesUseCaseFunction: MockFunction<UseCaseInput, Void>!

	var mockConversionFunction: MockFunction<City, CityPresentationData>!
	var expectedGetCitiesResult: Result<[City], Error>!
	var expectedCitiesPresentationData: [CityPresentationData]!

	override func setUp() {
		super.setUp()

		mockConnector = MockConnector()
		expectedCitiesPresentationData = [CityPresentationData(name: "", imageUrl: nil, indicator: "")]
		mockConversionFunction = MockFunction(output: expectedCitiesPresentationData[0])
		mockGetCitiesUseCaseFunction = MockFunction(output: ())

		sut = CitiesPresenter(
			connector: mockConnector,
			getCitiesUseCase: { showFavouritesOnly, callback  in
				self.mockGetCitiesUseCaseFunction.functionStub((showFavouritesOnly, callback))
				callback(self.expectedGetCitiesResult)
			},
			conversion: mockConversionFunction.functionStub
		)
	}

	func testOnLoadTriggerItGetsCities() {
		self.expectedGetCitiesResult = .success([City(name: "", imageUrl: nil, isFavourite: true)])

		let loadTrigger = ControlEvent<Void>()
		let input = CitiesPresenterInput(
			loadTrigger: loadTrigger,
			showFavouritesTrigger: ControlEvent<Bool>(),
			didSelectCityTrigger: ControlEvent<Int>()
		)
		_ = sut.transform(input)
		loadTrigger.event(value: ())

		XCTAssertEqual(mockGetCitiesUseCaseFunction.invocationsCount, 1)
	}

	func testWhenGettingCitiesSucceeds() {
		self.expectedGetCitiesResult = .success([City(name: "", imageUrl: nil, isFavourite: true)])

		let loadTrigger = ControlEvent<Void>()
		let input = CitiesPresenterInput(
			loadTrigger: loadTrigger,
			showFavouritesTrigger: ControlEvent<Bool>(),
			didSelectCityTrigger: ControlEvent<Int>()
		)
		let output = sut.transform(input)
		loadTrigger.event(value: ())

		let expectation = XCTestExpectation(description: "Load cities")

		output.cities.bind { data in
			XCTAssertEqual(data, self.expectedCitiesPresentationData)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)

		XCTAssertEqual(self.mockConnector.isLoadingToggleStatuses, [true, false])
	}

	func testWhenGettingCitiesFails() {
		expectedGetCitiesResult = .failure(Domain.Error.unableToLoadCities)

		let loadTrigger = ControlEvent<Void>()
		let input = CitiesPresenterInput(
			loadTrigger: loadTrigger,
			showFavouritesTrigger: ControlEvent<Bool>(),
			didSelectCityTrigger: ControlEvent<Int>()
		)

		_ = sut.transform(input)
		loadTrigger.event(value: ())

		let expectation = XCTestExpectation(description: "Load cities failure")

		mockConnector.didShowAlertCallback = { 
			XCTAssertEqual(self.mockConnector.showAlertInvocationsCount, 1)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)
		XCTAssertEqual(self.mockConnector.isLoadingToggleStatuses, [true, false])
	}

	func testOnDidSelectTriggerItShowsDetails() {
		let expectedCity = City(name: "Rzeszów", imageUrl: nil, isFavourite: true)
		self.expectedGetCitiesResult = .success([expectedCity])

		let loadTrigger = ControlEvent<Void>()
		let didSelectTrigger = ControlEvent<Int>()
		let input = CitiesPresenterInput(
			loadTrigger: loadTrigger,
			showFavouritesTrigger: ControlEvent<Bool>(),
			didSelectCityTrigger: didSelectTrigger
		)

		let output = sut.transform(input)
		loadTrigger.event(value: ())

		let expectationLoad = XCTestExpectation(description: "Load cities")

		output.cities.bind { data in
			XCTAssertEqual(data, self.expectedCitiesPresentationData)
			expectationLoad.fulfill()
		}

		wait(for: [expectationLoad], timeout: 1.0)

		let expectationDetails = XCTestExpectation(description: "Show details")
		mockConnector.didShowDetailsCallback = { city in
			XCTAssertEqual(city, expectedCity)
			expectationDetails.fulfill()
		}
		didSelectTrigger.event(value: 0)
		wait(for: [expectationDetails], timeout: 2.0)
	}

	// TODO: Add rest of the unit tests...
}

