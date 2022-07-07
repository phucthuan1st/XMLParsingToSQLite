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
    
    //MARK: move to FileHelper later
    func moveFileToOfficial() {
        let fileManager = FileManager.default
        let dirPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsDir = dirPath[0].path
        if !fileManager.changeCurrentDirectoryPath(docsDir) {
            cancelAlert(message: "Documents folder not exist")
            self.navigationController?.popViewController(animated: true)
        }

        do {
            
            let officialDataDir = dirPath[0].appendingPathComponent("official-data").path
            let dataDir = dirPath[0].appendingPathComponent("data").path
            
            
            if !fileManager.changeCurrentDirectoryPath(officialDataDir) {
                try fileManager.createDirectory(atPath: officialDataDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            progressingBar.setProgress(0.0, animated: true)
            self.progressingFile?.text = fileList.first
            var complete:Float = 0.0
            
            for file in self.fileList {
                
                let fromDir = dataDir + "/" + file
                let toDir = officialDataDir + "/" + file
                
                complete += self.copyItem(from: fromDir, to: toDir) / Float(self.fileList.count)
                DispatchQueue.main.async { [weak self] in
                    print("File: \(file) imported")
                    self?.progressingBar.setProgress(complete, animated: true)
                }
            }
        }
        catch {
            cancelAlert(message: error.localizedDescription)
        }
    }
    
    func copyItem(from:String, to:String) -> Float {
        do {
            try FileManager.default.copyItem(atPath: from, toPath: to)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return 1
    }
    //-----------------------------------------
    
    func cancelAlert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
