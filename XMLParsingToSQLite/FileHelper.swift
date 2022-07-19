import Foundation

class FileHelper {
    static let shared: FileHelper = FileHelper()
    
    var fileList:[String] {
        return Bundle.main.paths(forResourcesOfType: "xml", inDirectory: "data")
    }
    
    let fileManager = FileManager.default
    
    func existDirectory(Path dir:String) -> Bool {
        return fileManager.changeCurrentDirectoryPath(dir)
    }
    
    func createDirectory(Path dir:String) throws {
        try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: false)
    }
    
    func getFileList(On dataDir:String) throws -> [String] {
        var fileList = [String]()
        
        if dataDir != "" {
            fileList = try fileManager.contentsOfDirectory(atPath: dataDir)
            fileList = fileList.filter {$0.contains(".xml")}
        }
        
        return fileList
    }
	
    //MARK: copy an item to destination location
//    func copyItem(_ filePath:String) throws {
//
//        let toPath = pathToDir("official-data")
//
//        let fileName = filePath.split(separator: "/").last as! String
//
//        if !fileManager.fileExists(atPath: toPath) {
//            try fileManager.copyItem(atPath: fromPath, toPath: toPath)
//        }
//        else {
//            try fileManager.removeItem(atPath: toPath)
//            try fileManager.copyItem(atPath: fromPath, toPath: toPath)
//        }
//    }
    
    func copyXMLFileToOfficial() throws {

        let toPath = pathToDir("official-data")
        
        for file in fileList {
            let fileName = file.split(separator: "/").last!
            if !fileManager.fileExists(atPath: toPath + "/" + fileName) {
                try fileManager.copyItem(atPath: file, toPath: toPath + "/" + fileName)
            }
            //MARK: uncomment these code if wanna replace same file with other version
//            else {
//                try fileManager.removeItem(atPath: toPath + "/" + fileName)
//                try fileManager.copyItem(atPath: file, toPath: toPath + "/" + fileName)
//            }
        }
    }
    
    func pathToDir(_ dirName:String) -> String {
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = dir?.appendingPathComponent(dirName).path
        
        return path!
    }
}
