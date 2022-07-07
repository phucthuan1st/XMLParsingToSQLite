class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    let databaseFileName = "xmlDatabase.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    override init() {
        super.init()
     
        let fh = FileHelper.shared
        pathToDatabase = fh.pathToDir("official-data") + "/" + databaseFileName
    }
    
    func createDatabase() -> Bool {
        //MARK: change later
        let created = false
     
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
        }
        
        if database != nil {
            if !database.open() {
                print("Could not open the database.")
            }
        }
        return created
    }
    
    
}
