//
//  NetworkTests.swift
//  SwiftDemo
//
//  Created by panxinyu on 15/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import XCTest
@testable import SwiftDemo
import Alamofire

class NetworkTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAlamofireManager() {

    }

    let networkManager = NetworkManager.manager


    /// 直接测试网络和异步调用
    /// 其实 Alamofire 就有采用我上面说的方法进行测试，所以如果你的网络层像我一样是以 Alamofire 为基础构建的，
    /// 那就表示你不太需要再去写这样的测试了，你只要保证跟 Alamofire 无关的那些代码本身逻辑正确，以及正确调用了 Alamofire 即可。
    func testFetchDataWithAPI_invalidAPI_failureResult() {
        let test_expectation = expectation(description: "")
        let timeout = 15 as TimeInterval

        networkManager.fetchDataWithAPI(api: DouBanAPI.invalidURL, responseKey: "") {
            test_expectation.fulfill()
            XCTAssert($0.isFailure)
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }

    // MARK: - 测试 URL 是否合法的逻辑和调用 Alamofire 的逻辑正确
    func testFetchDataWithAPI_invalidAPI_returnNil() {
        let task = networkManager.fetchDataWithAPI(api: DouBanAPI.invalidURL, method: .get, responseKey: "", networkCompletionHandler: {_ in })
        XCTAssertNil(task)
    }

    func testFetchDataWithAPI_validAPI_returnNotNil() {
        let task = networkManager.fetchDataWithAPI(api: DouBanAPI.song, method: .get, responseKey: "", networkCompletionHandler: { _ in })
        XCTAssertNotNil(task)
    }

    // MARK: - 测试parseResult方法

    let testKey = "testKey"
    let jsonDictWithError: [String: Any] = ["code": 1]
    let jsonDictWithoutData: [String: Any] = ["code": 0]
    let jsonDictWithData: [String: Any] = ["testKey": "testValue"]

    let error = HTTPError.transformError

    func makeResultForFailureCaseWithError(error: Error) -> Result<Any> {
        return Result<Any>.failure(error)
    }

    func makeResultForSuccessCaseWithValue(value: Any) -> Result<Any> {
        return Result<Any>.success(value)
    }

    func testParseResult_failureCase_returnFailureCase() {
        let result = makeResultForFailureCaseWithError(error: error)
        let formattedResult = networkManager.parseResult(result: result, responseKey: testKey)

        XCTAssertTrue(formattedResult.isFailure)
    }

    func testParseResult_successCaseWithoutData_returnFailureCaseWithTransformFailed() {
        let result = makeResultForSuccessCaseWithValue(value: jsonDictWithoutData)
        let formattedResult = networkManager.parseResult(result: result, responseKey: testKey)
        XCTAssertEqual(formattedResult.error?.localizedDescription, HTTPError.transformError.localizedDescription)
    }

    func testParseResult_successCaseWithData_returnSuccess() {
        let result = makeResultForSuccessCaseWithValue(value: jsonDictWithData)
        let formattedResult = networkManager.parseResult(result: result, responseKey: testKey)
        XCTAssertEqual(formattedResult.value as? String, "testValue")
    }
}
