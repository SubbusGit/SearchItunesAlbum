//
//  SearchTests.swift
//  SearchTests
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import XCTest
@testable import Search

class SearchTests: XCTestCase {

    var  searchTestModel:AlbumSearchViewModel!
    var searchVC:AlbumSearchViewController!
     var resultsVC:AlbumResultsViewController!
    var resultTestModel:AlbumResultsViewModel!
    override func setUpWithError() throws {
        searchVC = AlbumSearchViewController()
        resultsVC = AlbumResultsViewController()
        searchTestModel = AlbumSearchViewModel(viewController: searchVC)
        resultTestModel = AlbumResultsViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        searchVC = nil
        searchTestModel = nil
        resultTestModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetSearchText() throws {
        let textField = UITextField()
        let testValue = "Test"
        textField.text = testValue
        textField.tag = 0 //Artist name
        searchTestModel.textFieldDidEndEditing(textField)
        XCTAssert(searchTestModel.albumToSearch?.artistName == testValue, "Value Set failure")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testAllEmptyFields() throws {
        
        searchTestModel.validate { (error) in
            XCTAssert(error != nil, "Validation is not done properly")
        }
           
       }
    func testEmptyTrackName() throws {
        searchTestModel.albumToSearch?.artistName = "Abc"
        //Only artist name is given , hence error should be returned since track name is also mandatory
        
           searchTestModel.validate { (error) in
               XCTAssert(error != nil, "Validation is not done properly")
           }
              
          }
    func testValidInputs() throws {
    searchTestModel.albumToSearch?.artistName = "Abc"
        searchTestModel.albumToSearch?.trackName = "Abc"
    //Only artist name is given , hence error should be returned since track is also mandatory
    
       searchTestModel.validate { (error) in
           XCTAssert(error == nil, "Validation is not done properly")
       }
          
      }
    func testCurrentTextField() throws {
        let textField = UITextField()
        searchTestModel.textFieldDidBeginEditing(textField)
        XCTAssertTrue(searchVC.currentField != nil, "Text field assigned correctly")
    }
func testGetText() throws {
    searchTestModel.albumToSearch?.artistName = "XYZ"
   
       XCTAssertTrue(searchTestModel.getText(for: .artistName) == "XYZ", "Text values returned correctly")
   }
    func testResultData() {
        resultTestModel.getApiData(url: resultsVC.BASE_URL) {
            XCTAssertTrue(self.resultTestModel.albums != nil, "Valid result is returned and assigned correctly")
        }
    }
    func testSortByArtistName() throws {
        resultTestModel.albums = [AlbumModel(artistName: "Xyz", trackName: "Abc", collectionName: "", collectionPrice: 99.0, releaseDate: nil, artworkUrl100: nil),
                                  AlbumModel(artistName: "Abc", trackName: "Xyz", collectionName: "", collectionPrice: 84, releaseDate: nil, artworkUrl100: nil)]
        resultTestModel.updateTableOrder(with: .artistName)
        XCTAssertTrue(resultTestModel.albums?.first?.artistName == "Abc", "Sort by artist name works")
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
