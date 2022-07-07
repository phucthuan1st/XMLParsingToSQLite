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
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        moveFileToOfficial()
        dispatchGroup.leave()
    }
}

extension loadingViewController {
    
    //MARK: move to FileHelper later
    func moveFileToOfficial() {
        do {
            
            let fh = FileHelper()
            
            if !fh.existDirectory(Path: fh.pathToDir("official-data")) {
                try fh.createDirectory(Path: fh.pathToDir("official-data"))
            }
            
            progressingBar.setProgress(0.0, animated: true)

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
            Alert(message: error.localizedDescription)
        }
    }
    //-----------------------------------------
    
    func Alert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
}
