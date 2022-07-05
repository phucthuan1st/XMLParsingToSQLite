//
//  ViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 04/07/2022.
//

import UIKit

class importViewController: UIViewController {
    
    @IBOutlet weak var fileTable: UITableView!
    
    let fileManager = FileManager.default
    var fileList = [String]()
    var selectedList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDataFileOnStorage()
        
    }

    @IBAction func didTapImport(_ sender: Any) {
        print("import \(selectedList)")
    }
}

extension importViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fileTable.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileCell
        
        cell.fileName.text = fileList[indexPath.section]
        cell.check.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        cell.check.isHidden = false
        
        selectedList.append(cell.fileName.text!)
        print(selectedList)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        
        cell.check.isHidden = true
        selectedList.removeAll(where: {$0 == cell.fileName.text})
        print(selectedList)
    }
    
    func showDataFileOnStorage() {
        getFileList(From: dataDir())
        fileTable.allowsMultipleSelection = true
        fileTable.dataSource = self
        fileTable.delegate = self
    }
}

extension importViewController {
    func dataDir() -> String {
        let dirPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        do {
            let docsDir = dirPath[0].path

            if !fileManager.changeCurrentDirectoryPath(docsDir) {
                let alert = UIAlertController(title: "Warning", message: "Documents folder not exist", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            }
            
            let dataDir = dirPath[0].appendingPathComponent("data").path
            
            if !fileManager.changeCurrentDirectoryPath(dataDir) {
                try fileManager.createDirectory(atPath: dataDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            return dataDir
        }
        catch {
            let alert = UIAlertController(title: "Warning", message: "Error when try to load data or missing directory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            return ""
        }
    }
    
    func getFileList(From dataDir:String) {
        if dataDir == "" {
            fileList = []
        }
        else {
            do {
                let dataQueue = DispatchQueue(label: "public.load.fileList")
                try dataQueue.sync {
                    fileList = try fileManager.contentsOfDirectory(atPath: dataDir)
                }
                
                fileList = fileList.filter {$0.contains(".xml")}
            }
            catch {
                let alert = UIAlertController(title: "Warning", message: "Error when try to load data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            }
        }
    }
}

class FileCell : UITableViewCell {
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var fileName: UILabel!
}



