//
//  VIPERTests.swift
//  VIPERTests
//
//  Created by Admin on 12.11.2021.
//

import XCTest
@testable import VIPER

var sut: ViewController! // system under test
var sut1: UserInteractor!

class VIPERTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ViewController()
        sut1 = UserInteractor()
        // Put setup code here. This method is called before the invocation of each test method in the class. // Поместите сюда установочный код. Этот метод вызывается перед вызовом каждого тестового метода в классе.
    }
    
    override func tearDownWithError() throws {
        sut = nil
        sut1 = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class. // Поместите здесь код разборки. Этот метод вызывается после вызова каждого тестового метода в классе.
    }
//    func testCheckSumm() {
//        // given (дано)
//        let result = sut.one + sut.two
//        // when (когда)
//        sut.summ()
//        // then (тогда)
//        XCTAssertEqual(result, 40, "Error!")
//    }
//    func testSaveToBD() {
//        let inputData = "AllCharactersProxy"
//        XCTAssertNoThrow(sut1.saveTobd(this: inputData))
//        XCTAssertEqual(inputData, "AllCharactersProxy", "Error!")
//    }
}


