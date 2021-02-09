//
//  ReactiveHelpers.swift
//  Presentation
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

public class BehaviorSubject<T> {

	public typealias Observer = (T) -> ()
	public var observer: Observer?

	public var value: T {
		didSet {
			observer?(value)
		}
	}

	public init(_ v: T) {
		value = v
	}

	public func bind(_ observer: Observer?) {
		self.observer = observer
	}

	public func bindAndReply(_ observer: Observer?) {
		self.observer = observer
		observer?(value)
	}
}

public class ControlEvent<T> {

	public typealias Observer = (T) -> ()
	public var observer: Observer?
	public var currentValue: T? = nil

	public func bind(_ observer: Observer?) {
		self.observer = observer
	}

	public func event(value: T) {
		currentValue = value
		observer?(value)
	}

	public init() {}
}
