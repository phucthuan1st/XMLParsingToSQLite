//
//  XMLParsingToSQLiteTests.swift
//  XMLParsingToSQLiteTests
//
//  Created by MacMini01 on 14/07/2022.
//

import XCTest

class XMLParsingToSQLiteTestFileHelper: XCTestCase {

	// MARK: FileHelper test
    func testCheckExists() throws {
        let docsDir = FileHelper.shared.pathToDir("")
        XCTAssertTrue(FileHelper.shared.existDirectory(Path: docsDir))
		XCTAssertTrue(docsDir.contains("Documents"))
    }
	
	func testGetInvalidFileList() throws {
		let fileList = FileHelper.shared.fileList
		
		var isValid = true
		
		for file in fileList {
			if !file.contains(".xml") {
				isValid = false
			}
		}
		
		XCTAssertTrue(isValid)
	}

	func testCopyFile() throws {
		let fh = FileHelper.shared
		
		var fileList = fh.fileList
		var fileNameOnBundle = [String]()
		
		for file in fileList {
			let name = file.split(separator: "/").last
			fileNameOnBundle.append(String(name!))
		}
		
		try FileHelper.shared.copyXMLFileToOfficial()
		fileList = try fh.getFileList(On: fh.pathToDir("official-data"))
		var fileNameOnOffcialData = [String]()
		
		for file in fileList {
			let name = file.split(separator: "/").last
			fileNameOnOffcialData.append(String(name!))
		}
		
		XCTAssertEqual(fileNameOnOffcialData, fileNameOnBundle)
	}
}

class XMLParsingToSQLiteTestDBManager : XCTestCase {
	
	func testValidDatabasePath() throws {
		let pathToDatabase = DBManager.shared.pathToDatabase!
		
		XCTAssertTrue(pathToDatabase.contains("official-data"))
		XCTAssertTrue(pathToDatabase.contains(".db"))
		XCTAssertTrue(FileManager.default.fileExists(atPath: pathToDatabase))
	}
	
	func testInsertRecordFromDB() throws {
		let invalidRecord = Record()
		var success:Bool?
		
		DBManager.shared.insertRecord(record: invalidRecord, completion: { isSuccess in
			success = isSuccess
		})
		
		XCTAssertTrue(success == false)
		
		let validRecord = Record(instanceID: "test", instanceName: "test")
		
		DBManager.shared.insertRecord(record: validRecord, completion: { isSuccess in
			success = isSuccess
		})
		
		let deleteQuery = String(format: "DELETE FROM XML WHERE instanceID = ?")
		DBManager.shared.queue?.inTransaction { database, rollback in
			do {
				try database.executeUpdate(deleteQuery, values: ["test"])
			}
			catch {
				rollback.pointee = true
			}
		}
		
		XCTAssertTrue(success == true)
	}
	
	func testFetchRecordFromDB() throws {
		
	}
}
