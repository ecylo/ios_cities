//
//  MockFunction.swift
//  PlatformTests
//
//  Created by Ewelina on 10/02/2021.
//

import Foundation

class MockFunction<Input, Output> {

	private let output: Output
	var invocationsCount: Int = 0

	var functionStub: (Input) -> Output {
		return { _ in
			self.invocationsCount += 1
			return self.output
		}
	}

	init(output: Output) {
		self.output = output
	}
}
