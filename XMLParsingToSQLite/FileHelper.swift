//
//  FileHelper.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 07/07/2022.
//

import Foundation

class FileHelper {
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
    
    func copyItem(from:String, to:String) throws {
        
        if !existDirectory(Path: to) {
            try createDirectory(Path: to)
        }
        
        fileManager.changeCurrentDirectoryPath(to)
        if fileManager.fileExists(atPath: from) {
            try fileManager.copyItem(atPath: from, toPath: to)
        }
        else {
            print("file \(from) not exist")
        }
    }
    
    func pathToDir(_ dirName:String) -> String {
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = dir?.appendingPathComponent(dirName).path
        
        return path!
    }
}
