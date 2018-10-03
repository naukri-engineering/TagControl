//
//  NRTagControlLibraryTests.swift
//  NRTagControlLibraryTests
//
//  Created by Bhumika Goyal on 01/10/18.
//  Copyright © 2018 Bhumika Goyal. All rights reserved.
//


import XCTest
@testable import NRTagControlLibrary

class NRTagControlLibraryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingModelToArray() {
        
        let expectation = self.expectation(description: "Test add Tag method")
        let tagView = NRTagsControl(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        var tagArray = [TagModel]()
        let tagModel = TagModel(id: "0", name: "Hello")
        tagArray.append(tagModel)
        let tagModel2 = TagModel(id: "1", name: "abc@gmail.com")
        tagArray.append(tagModel2)
        tagView.tags = tagArray
        tagView.reloadTagSubviewsWithModel()
        XCTAssert(tagView.tags?.count != nil, "This cant be nil")
        XCTAssert(tagView.tags?.count == 2, "Count must  be equal to 2")
        XCTAssert(tagView.tags?.first?.name == "Hello", "Name should be same")
        
        
        expectation.fulfill()
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Should not return error")
        }
        
    }
    
    func testAddTagMethod() {
        
        let expectation = self.expectation(description: "Test add Tag method")
        let tagView = NRTagsControl(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        let tagModel = TagModel(id: "0", name: "abc@gmail.com")
        tagView.addTag(withModel: tagModel)
        
        tagView.reloadTagSubviewsWithModel()
        XCTAssert(tagView.tags?.count != nil, "This cant be nil")
        XCTAssert(tagView.tags?.count == 1, "Count must  be equal to 2")
        XCTAssert(tagView.tags?.first?.name == "abc@gmail.com", "Name should be same")
        
        expectation.fulfill()
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Should not return error")
        }
        
    }
    
}
