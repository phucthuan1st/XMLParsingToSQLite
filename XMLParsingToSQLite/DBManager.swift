struct Record {
    var instanceID:String?
    var instanceName:String?
}

class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    let databaseFileName = "xmlDatabase.db"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    let createTableQuery = """
        CREATE TABLE XML (
            instanceID text not null primary key,
            instanceName text
        )
        """
    
    override init() {
        super.init()
     
        let fh = FileHelper.shared
        pathToDatabase = fh.pathToDir("official-data") + "/" + databaseFileName
    }
    
    func createDatabase() -> Bool {
        var created = false
     
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
     
            if database != nil {
                // Open the database.
                if database.open() {
     
                    do {
                        try database.executeUpdate(createTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }

                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        else {
            database = FMDatabase(path: pathToDatabase!)
            do {
                try database.executeUpdate(createTableQuery, values: nil)
            }
            catch {
                print(error)
            }
        }
     
        return created
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
            else {
                if createDatabase() {
                    print("New database created")
                }
            }
        }
        
        if database != nil {
            return database.open()
        }
        
        return false
    }
    
    func insertRecord(record:Record) -> Bool {
        let query = "INSERT INTO XML VALUES (\"\(record.instanceID!)\", \"\(record.instanceName!)\")"
        if !openDatabase() {
            print("cannot open database")
            database.close()
            return false
        }
        else {
            do {
                try database.executeUpdate(createTableQuery, values: nil)
                try database.executeUpdate(query, values: nil)
                database.close()
                return true
            }
            catch {
                print("cannot insert \(record): - \(error.localizedDescription)")
                database.close()
                return false
            }
        }
    }
    
    func loadRecord() -> [Record] {
        if openDatabase() {
            let query = "select * from XML"
        
            do {
                
                let result = try database.executeQuery(query, values: nil)
                
                var xmlRecord = [Record]()
                
                while result.next() {
                    let record = Record(instanceID: result.string(forColumn: "instanceID"),
                                        instanceName: result.string(forColumn: "instanceName"))
                    
                    xmlRecord.append(record)
                }
                
                database.close()
                return xmlRecord
            }
            catch {
                print(error.localizedDescription)
                database.close()
                return [Record]()
            }
        }
        
        return [Record]()
    }
}
