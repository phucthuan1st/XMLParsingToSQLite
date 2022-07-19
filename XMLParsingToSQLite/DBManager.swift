import FMDB

struct Record {
    var instanceID:String?
    var instanceName:String?
}

class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    let databaseFileName = "xmlDatabase.db"
    var pathToDatabase: String!
	
	var queue:FMDatabaseQueue? {
		return FMDatabaseQueue(path: pathToDatabase)
	}
    
    override init() {
        super.init()
     
        let fh = FileHelper.shared
        pathToDatabase = fh.pathToDir("official-data") + "/" + databaseFileName
    }
    
	// MARK: older version
//    func createDatabase() -> Bool {
//        var created = false
//
//        if !FileManager.default.fileExists(atPath: pathToDatabase) {
//            database = FMDatabase(path: pathToDatabase!)
//
//            if database != nil {
//                // Open the database.
//                if database.open() {
//
//                    do {
//                        try database.executeUpdate(createTableQuery, values: nil)
//                        print("Table created")
//                        created = true
//                    }
//                    catch {
//                        print("Could not create table.")
//                        print(error.localizedDescription)
//                    }
//
//                    database.close()
//                }
//                else {
//                    print("Could not open the database.")
//                }
//            }
//        }
//        else {
//            database = FMDatabase(path: pathToDatabase!)
//            do {
//                try database.executeUpdate(createTableQuery, values: nil)
//                print("Table created")
//            }
//            catch {
//                print(error)
//            }
//        }
//
//        return created
//    }
//
//    func openDatabase() -> Bool {
//        if database == nil {
//            if FileManager.default.fileExists(atPath: pathToDatabase) {
//                database = FMDatabase(path: pathToDatabase)
//            }
//            else {
//                if createDatabase() {
//                    print("New database created")
//                }
//            }
//        }
//
//        if database != nil {
//            return database.open()
//        }
//
//        return false
//    }
    
	func insertRecord(record:Record, completion: (Bool) -> ()) {
		let query = String(format: "INSERT INTO XML VALUES (?, ?)")
		guard let id = record.instanceID else {
			completion(false)
			return
		}
		
		guard let name = record.instanceName else {
			completion(false)
			return
		}
		
		let createTableQuery = """
			CREATE TABLE IF NOT EXISTS XML (
				instanceID text not null primary key,
				instanceName text
			)
			"""

		queue?.inTransaction { database, rollback in
            do {
                try database.executeUpdate(createTableQuery, values: nil)
				try database.executeUpdate(query, values: [id, name])
				completion(true)
            }
            catch {
				rollback.pointee = true
				completion(false)
            }
        }
    }
    
    func fetchRecord(completion: @escaping ([Record]) -> ()) {
		
		queue?.inTransaction { database, rollback in
			do {
				let query = "SELECT * FROM XML"
				
				let result = try database.executeQuery(query, values: nil)
				
				var xmlRecord = [Record]()
				
				while result.next() {
					let record = Record(instanceID: result.string(forColumn: "instanceID"),
										instanceName: result.string(forColumn: "instanceName"))
					
					xmlRecord.append(record)
				}
				completion(xmlRecord)

			}
			catch {
				rollback.pointee = true
				completion([])
			}
		}
	}
	
}
