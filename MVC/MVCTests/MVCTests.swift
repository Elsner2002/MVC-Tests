//
//  MVCTests.swift
//  MVCTests
//
//  Created by Felipe  Elsner Silva on 25/03/24.
//

import XCTest

@testable
import MVC

class MockClient: HTTPClient {
    var json = ""
    var sc = 0
    
    func perform(_ apiAddress: String) {
        json = """
            {
                
            }
            """
        
        sc = 200
    }
    
    func jsonToReturn() -> String {
        return json
    }
    
    func statusCodeWork() -> Bool {
        var result = false
        if sc == 200 {
            result = true
        }
        else {
            result = false
        }
        return result
    }
}

class MockService: Service {
    
    var data: Data?
    
    func apiCall() {
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2, execute: {
            let newData = Data()
            self.data = newData
        })
    }
    
    func returnData() -> Data? {
        return data
    }
}

final class MVCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testManualDecode() throws {
        let mc = MockClient()
        mc.perform("")
        var test = mc.jsonToReturn()
        
        XCTAssertNotNil(test)
    }
    
    func testStatusCode() throws {
        let mc = MockClient()
        mc.perform("")
        var result = mc.statusCodeWork()
        
        XCTAssertTrue(result)
    }
    
    func testApiCall() throws {
        let ms = MockService()
        ms.apiCall()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2, execute: {
            var result = ms.returnData()
            XCTAssertNotNil(result)
        })
    }
    
    func testImageRequest() throws {
        MovieDBService.fetchImage(posterPath: "/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg") { data in
            XCTAssertNotNil(data)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
