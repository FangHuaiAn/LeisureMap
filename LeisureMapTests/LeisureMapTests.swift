//
//  LeisureMapTests.swift
//  LeisureMapTests
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import XCTest
@testable import LeisureMap

class LeisureMapTests: XCTestCase {
    
    var sqliteWorker : SQLiteWorker?
    
    override func setUp() {
        super.setUp()
        //
        sqliteWorker = SQLiteWorker()
        sqliteWorker?.createDatabase()
    }
    
    override func tearDown() {
        //
        super.tearDown()
        
        sqliteWorker?.clearAll()
    }
    
    func testInsert() {
        //
        
        sqliteWorker?.insertData(_name: "service01", _imagepath: "imagepath")
        
        let results = sqliteWorker?.readData()
        
        XCTAssert(results?.count == 1, "passed")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            sqliteWorker?.insertData(_name: "service01", _imagepath: "imagepath")
            
            _ = sqliteWorker?.readData()
        }
    }
    
}
