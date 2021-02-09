//
//  Environment.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

protocol Environmentable {
	var baseUrl: URL { get }
}

enum Environment {
	case production
}

extension Environment: Environmentable {
	var baseUrl: URL {
		URL(string: "https://gist.githubusercontent.com/ecylo")!
	}
}

