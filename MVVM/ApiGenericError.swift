//
//  ApiGenericError.swift
//  MVVM
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import Foundation

enum ApiGenericError: Error {
	
	case requestFailed(description: String)
	case responseUnsuccessful(description: String)
	case invalidUrl(description: String)
	
	var customDescription: String {
		switch self {
			case let .requestFailed(description): return "Request Failed error -> \(description)"
			case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
			case let .invalidUrl(description): return "Invalid url -> \(description)"
		}
	}
}
