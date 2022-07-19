//
//  XMLParsingToSQLiteTests.swift
//  XMLParsingToSQLiteTests
//
//  Created by MacMini01 on 14/07/2022.
//

import XCTest

class XMLParsingToSQLiteTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

	// MARK: FileHelper test
    func testFileHelperPath() throws {
        //make sure can create a path to a dir
        XCTAssertNotNil(FileHelper.shared.pathToDir(""))
    }
    
    func testFileHelperCheckExists() throws {
        let docsDir = FileHelper.shared.pathToDir("")
        XCTAssertTrue(FileHelper.shared.existDirectory(Path: docsDir))
    }
    
    func testFileListOnBundle() throws {
        //make sure bundle contain default xml files
        XCTAssertNotNil(FileHelper.shared.fileList)
    }
    
    func testFileHelperSingleton() throws {
        XCTAssertNotNil(FileHelper.shared)
    }
    
	// MARK: DB Test
    func testDBManagerSingleton() throws {
        XCTAssertNotNil(DBManager.shared)
    }
    
    func testValidDatabasePath() throws {
        let pathToDatabase = DBManager.shared.pathToDatabase!
        
        XCTAssertTrue(pathToDatabase.contains("official-data"))
    }
    
    func testFetchRecordFromDB() throws {
        var rc = [Record]()
        
        XCTAssertNotNil(DBManager.shared.fetchRecord(completion: { data in
            rc = data
        }))
        
        print(rc)
    }

}
