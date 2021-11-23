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
	func post<T: Encodable, U: Decodable>(with data: T, endpoint: String) async throws -> U
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
	
	
	func post<T: Encodable, U: Decodable>(with data: T, endpoint: String, completion: @escaping (Result<U, ApiGenericError>) -> Void ) {
		
		guard let url = URL(string: endpoint) else {
			completion(.failure(.invalidUrl(description: "invalid url")))
			return
		}
		
		let encoder = JSONEncoder()
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = try? encoder.encode(data)
		
		let session = URLSession.shared
		let task = session.dataTask(with: request) { (data, response, error) in
			
			if let error = error {
				completion(.failure(.requestFailed(description: "Api returned error -> \(error)")))
			} else if let data = data {
				do {
					let decoded = try JSONDecoder().decode(U.self, from: data)
					completion(.success(decoded))
				} catch {
					completion(.failure(.decodeFailed(description: "Decoding failed")))
				}
			} else {
				completion(.failure(.responseUnsuccessful(description: "There was an unexpected error")))
			}
		}
		
		task.resume()
	}
	
}




extension UserService {
	func post<T: Encodable, U: Decodable>(with data: T, endpoint: String) async throws -> U {
		try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<U, Error>) in
			self.post(with: data, endpoint: endpoint) { (result: Result<U, ApiGenericError>) in
				switch result {
					case .success(let returnedData):
						continuation.resume(returning: returnedData)
					case .failure(let error):
						continuation.resume(throwing: error)
				}
			}
		}
	}
}
