//
//  UserService.swift
//  MVVM
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import Foundation
import Combine

protocol UserServiceProtocol {
	func fetch<T: Decodable>(to endpoint: String, type: T.Type) async throws -> T
}


class UserService: UserServiceProtocol {
	
	func fetch<T: Decodable>(to endpoint: String, type: T.Type) async throws -> T {
		
		guard let url = URL(string: endpoint) else {
			throw ApiGenericError.invalidUrl(description: "invalid url")
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw ApiGenericError.requestFailed(description: "invalid response")
		}
		
		guard httpResponse.statusCode == 200 else {
			throw ApiGenericError.responseUnsuccessful(description: "status code \(httpResponse.statusCode)")
		}

		let decoded = try JSONDecoder().decode(type, from: data)
		return decoded
	}
	
}
