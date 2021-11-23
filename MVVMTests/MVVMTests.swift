//
//  MVVMTests.swift
//  MVVMTests
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import XCTest
@testable import MVVM


class MockUserService: UserServiceProtocol {
	func post<T, U>(with data: T, endpoint: String) async throws -> U where T : Encodable, U : Decodable {
		let post = PostModel(userId: 1, id: 1, title: "Some Post", body: "Some body")
		return post as! U
	}
	
	func fetch<T>(to endpoint: String, type: T.Type) async throws -> T where T : Decodable {
		let users = [UserModel(id: 1, username: "Bobo", email: "Bobo@me.com")]
		return users as! T
	}
}


class MVVMTests: XCTestCase {
	
	var sut: UsersView.ViewModel!

    override func setUpWithError() throws {
		sut = UsersView.ViewModel(userService: MockUserService())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

	func test_getUsers() async {
		XCTAssertTrue(sut.users.isEmpty)
		await sut.getUsers()
		XCTAssertGreaterThan(sut.users.count, 0, "")
		XCTAssertEqual(sut.users.first?.username, "Bobo")
	}
	
	func test_makePost() async {
		XCTAssertTrue(sut.posts.isEmpty)
		await sut.makePost()
		XCTAssertGreaterThan(sut.posts.count, 0, "")
		XCTAssertEqual(sut.posts.first?.title, "Some Post")
	}

}
