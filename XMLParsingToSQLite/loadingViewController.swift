//
//  loadingViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 05/07/2022.
//

import UIKit

class loadingViewController: UIViewController {
    
    @IBOutlet weak var progressingBar: UIProgressView!
    
    var fileList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressingBar.setProgress(0.0, animated: false)
        
        DispatchQueue.global().async {
            self.moveFileToOfficial()
        }
    }
}

extension loadingViewController {
    
    //MARK: move to FileHelper later
    func moveFileToOfficial() {
        let fh = FileHelper()
        do {
            let dataDir = fh.pathToDir("data")
            let officialDataDir = fh.pathToDir("official-data")
            
            var complete:Float = 0.0
            
            for file in self.fileList {
                print(file)
                let fromFileDir = dataDir + "/" + file
                let toFileDir = officialDataDir + "/" + file
                
                print(fromFileDir)
                print(toFileDir)
                try fh.copyItem(from: fromFileDir, to: toFileDir)
                complete += 1.0 / Float(fileList.count)
                
                DispatchQueue.main.async { [weak self] in
                    self?.progressingBar.setProgress(complete, animated: true)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    //-----------------------------------------
    
    func cancelAlert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
