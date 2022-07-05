//
//  ViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 04/07/2022.
//

import UIKit

class importViewController: UIViewController {
    
    @IBOutlet weak var fileTable: UITableView!
    let test = ["Banana", "Apple", "Pear", "Durian", "Orange"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        showDataFileOnStorage()
    }
}

extension importViewController {
    
}

extension importViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fileTable.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileCell
        
        cell.fileName.text = test[indexPath.section]
        cell.fileSize.text = "1"
        cell.check.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        cell.check.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        
        cell.check.isHidden = true
    }
    
    func showDataFileOnStorage() {
        fileTable.allowsMultipleSelection = true
        fileTable.dataSource = self
        fileTable.delegate = self
    }
}

class FileCell : UITableViewCell {
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var fileName: UILabel!
}



