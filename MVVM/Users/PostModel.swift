//
//  PostModel.swift
//  MVVM
//
//  Created by Vasileios  Gkreen on 22/11/21.
//

import Foundation

struct PostModel: Identifiable, Codable {
	var userId: Int
	var id: Int
	var title: String
	var body: String
}
