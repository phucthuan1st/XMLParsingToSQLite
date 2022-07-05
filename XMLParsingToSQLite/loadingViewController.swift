//
//  loadingViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 05/07/2022.
//

import UIKit

class loadingViewController: UIViewController {
    
    @IBOutlet weak var progressingFile: UILabel!
    @IBOutlet weak var progressingBar: UIProgressView!
    
    var fileList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveFileToOfficial()
    }
}

extension loadingViewController {
    func moveFileToOfficial() {
        //let movingQueue = DispatchQueue(label: "public.moving.official")
        let fileManager = FileManager.default
        let dirPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsDir = dirPath[0].path
        
        do {
            if !fileManager.changeCurrentDirectoryPath(docsDir) {
                cancelAlert(message: "Documents folder not exist")
            }
            
            let officialDataDir = dirPath[0].appendingPathComponent("official-data").path
            let dataDir = dirPath[0].appendingPathComponent("data").path
            
            
            if !fileManager.changeCurrentDirectoryPath(officialDataDir) {
                try fileManager.createDirectory(atPath: officialDataDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            for file in self.fileList {
                let dir = dataDir + "/" + file
                    
                self.progressingBar.progress += 1 / Float(self.fileList.count)
                    
                self.progressingBar.setProgress(self.progressingBar.progress, animated: true)
            }
        }
        catch {
            print(error)
            cancelAlert(message: "Error when try to load data or missing directory")
        }
    }
    
    func copyItem(from:String, to:String) -> Float {
        do {
            try FileManager.default.copyItem(atPath: from, toPath: to)
        }
        catch {
            print(error)
        }
        
        return 1
    }
    
    func cancelAlert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
