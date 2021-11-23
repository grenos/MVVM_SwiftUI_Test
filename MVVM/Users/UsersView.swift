//
//  UsersView.swift
//  MVVM
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import SwiftUI

struct UsersView: View {
	
	@StateObject var viewModel = ViewModel()
	
    var body: some View {
		List(viewModel.users) { user in
			VStack(alignment: .leading) {
				Text(user.username)
					.padding(.bottom, 5)
					.font(.title)
				Text(user.email)
			}
		}
		
		
		.task {
			await viewModel.getUsers()
			await viewModel.makePost()
		}
    }
}

 


struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
		let user = UserModel(id: 1, username: "Bobo", email: "Bobo@me.com")
		let viewModel = UsersView.ViewModel()
		viewModel.users = [user]
		
        return UsersView(viewModel: viewModel)
    }
}
