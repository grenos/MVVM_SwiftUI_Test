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
		@Published var posts = [PostModel]()
		
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
		

		func makePost() async {
			let data = PostModel(userId: 2, id: 12, title: "Sex Pistols", body: "The truth is in Sex Pistols")

			do {
				let postResponse = try await userService.post(with: data, endpoint: "https://jsonplaceholder.typicode.com/posts") as PostModel
				await MainActor.run { posts.append(postResponse) }
			} catch {
				print(error)
			}
		}
	}
}
