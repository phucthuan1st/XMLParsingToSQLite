//
//  loadingViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 05/07/2022.
//

import UIKit

struct XMLInfo {
    var instanceID:String?
    var instanceName:String?
}

class loadingViewController: UIViewController {
    
    @IBOutlet weak var progressingBar: UIProgressView!
    
    var fileList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressingBar.setProgress(0.0, animated: true)
        moveFileToOfficial()
    }
}

extension loadingViewController {
    
    //MARK: move to FileHelper later
    func moveFileToOfficial() {
        DispatchQueue.global().async {

            do {
                let fh = FileHelper.shared
                
                if !fh.existDirectory(Path: fh.pathToDir("official-data")) {
                    try fh.createDirectory(Path: fh.pathToDir("official-data"))
                }

                var complete:Float = 0.0
                    
                for file in self.fileList {
                    try fh.copyItem(from: "data/" + file, to: "official-data/" + file)
                    complete += 1.0 / Float(self.fileList.count)
                    
                    DispatchQueue.main.async { [weak self] in
                        print("File: \(file) imported")
                        self?.progressingBar.setProgress(complete, animated: true)
                    }
                }
                
            }
            catch {
                self.Alert(message: error.localizedDescription)
            }
        }
    }
    
    func storeXMLValue() {
        
    }
    
    func writeXMLInfoToDataBase() {
        
    }
    //-----------------------------------------
    
    func Alert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
}
