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
    
    func perform(_ apiAddress: String) {
        json = """
            {
                
            }
            """
    }
    
    func jsonToReturn() -> String {
        perform("")
        return json
    }
}

//struct MockService: Service {
//    func apiCall() {
//        
//        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2, execute: {
//            let data = Data()
//        })
//        
//        return data()
//    }
//}

final class MVCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testManualDecode() throws {
        let mc = MockClient()
        var test = mc.jsonToReturn()
        
        //
//        guard let urlNP = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=2d4b4abbcf1392ca7691bf7d93f415c9&language=en-US&page=1") else { return }
//        URLSession.shared.dataTask(with: urlNP) { data, response, error in
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200,
//                  error == nil,
//                  let data = data
//            else {
//                print(error ?? "error")
//                return
//            }
//            XCTAssertTrue(MovieService.shared.decodeByManualKeys(data: data, type: .nowPlaying))
//        }
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
