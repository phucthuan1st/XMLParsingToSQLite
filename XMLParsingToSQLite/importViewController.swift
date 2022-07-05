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
    var selectedList = [String]() {
        didSet {
            selectedList.sort()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDataFileOnStorage()
        
    }

    @IBAction func didTapImport(_ sender: Any) {
        if selectedList.isEmpty {
            cancelAlert(message: "Empty selection")
        }
        else {
            let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "loadingViewController") as! loadingViewController
            
            loadingView.fileList = selectedList
            
            self.navigationController?.pushViewController(loadingView, animated: true)
        }
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
                cancelAlert(message: "Documents folder not exist")
            }
            
            let dataDir = dirPath[0].appendingPathComponent("data").path
            
            if !fileManager.changeCurrentDirectoryPath(dataDir) {
                try fileManager.createDirectory(atPath: dataDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            return dataDir
        }
        catch {
            cancelAlert(message: "Error when try to load data or missing directory")
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
                    fileTable.reloadData()
                }
                
                fileList = fileList.filter {$0.contains(".xml")}.sorted()
                
                print(fileList)
                
                if fileList.isEmpty {
                    cancelAlert(message: "Data folder is empty")
                }
            }
            catch {
                cancelAlert(message: "Error when try to load data")
            }
        }
    }
}

extension importViewController {
    func cancelAlert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

class FileCell : UITableViewCell {
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var fileName: UILabel!
}



