//
//  UsersViewModel.swift
//  MVVM
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import SwiftUI


extension UsersView {
	
	//	@MainActor
	final class ViewModel: ObservableObject {
		
		@Published var users = [UserModel]()
		
		let userService: UserServiceProtocol
		
		init(userService: UserServiceProtocol = UserService()) {
			self.userService = userService
		}
		
		func getUsers() async {
			do {
				let usersResponse = try await userService.fetch(to: "https://jsonplaceholder.typicode.com/users", type: [UserModel].self)
				await MainActor.run { users = usersResponse }
			} catch {
				print(error)
			}
		}
	}
}
