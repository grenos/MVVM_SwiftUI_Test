//
//  MVVMTests.swift
//  MVVMTests
//
//  Created by Vasileios  Gkreen on 17/11/21.
//

import XCTest
@testable import MVVM


class MockUserService: UserServiceProtocol {
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

}
