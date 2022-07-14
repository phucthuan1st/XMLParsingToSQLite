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

//MARK: table view configuration
extension importViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fileTable.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileCell
        
        let fileName = fileList[indexPath.section].split(separator: "/").last
        cell.fileName.text = String(fileName!)
        cell.check.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        cell.check.isHidden = false
        
        selectedList.append(cell.fileName.text!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        
        cell.check.isHidden = true
        selectedList.removeAll(where: {$0 == cell.fileName.text})
    }
    
    func showDataFileOnStorage() {

        let fh = FileHelper()
        fileList = fh.fileList
        fileList.sort()
        
        fileTable.allowsMultipleSelection = true
        fileTable.dataSource = self
        fileTable.delegate = self
    }
}

// MARK: Alert template
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



