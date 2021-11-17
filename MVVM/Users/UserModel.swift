//
//  UserModel.swift
//  MVVM
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import Foundation


struct UserModel: Identifiable, Codable {
	var id: Int
	var username: String
	var email: String
}
