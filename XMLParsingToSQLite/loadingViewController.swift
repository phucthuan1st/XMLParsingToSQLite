//
//  loadingViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 05/07/2022.
//

import UIKit

class loadingViewController: UIViewController {
    
    @IBOutlet weak var progressingBar: UIProgressView!
    
    var elementName:String?
    var fileList = [String]()
    
    var record:Record?
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressingBar.setProgress(0.0, animated: true)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.moveFileToOfficial()
                for file in self.fileList {
                    try self.handleForXMLInstace(path: file)
                }
                
                let progress = 1.0 + Float(self.fileList.count)
                DispatchQueue.main.async {
                    self.progressingBar.setProgress(progress, animated: true)
                    
                    if self.progressingBar.progress == 1.0 {
                        let xmlViewController = self.storyboard?.instantiateViewController(withIdentifier: "xmlViewController") as! xmlViewController
                        
                        //xmlViewController.records = self.records
                        
                        self.navigationController?.popViewController(animated: false)
                        self.navigationController?.pushViewController(xmlViewController, animated: true)
                    }
                }
                
            }
            catch {
                self.Alert(message: error.localizedDescription)
            }
        }
    }
    
    func Alert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
}

extension loadingViewController {
    
    //MARK: move to FileHelper later
    func moveFileToOfficial() throws {

        let fh = FileHelper.shared
        
        if !fh.existDirectory(Path: fh.pathToDir("official-data")) {
            try fh.createDirectory(Path: fh.pathToDir("official-data"))
        }

        try fh.copyXMLFileToOfficial()
    }
}

extension loadingViewController : XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "instanceID" {
            record = Record(instanceID: "", instanceName: "")
            self.elementName = elementName
        }
        if elementName == "instanceName" {
            if record == nil {
                record = Record(instanceID: "Unknown ID", instanceName: "")
            }
            self.elementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "instanceID" {
        }
        if elementName == "instanceName" {
            records.append(record!)
            if DBManager.shared.insertRecord(record: record!) {
                print("Insert record successfully")
            }
            record = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if (!string.isEmpty) {

            if self.elementName == "instanceID" {
                record?.instanceID! += string
            }
            if self.elementName == "instanceName" {
                record?.instanceName! += string
            }
        }
    }
}

extension loadingViewController {
    func handleForXMLInstace(path:String) throws {
        let filePath = FileHelper.shared.pathToDir("official-data") + "/" + path
        let inputStream = InputStream(fileAtPath: filePath)
        let xmlParser = XMLParser(stream: inputStream!)
        
        xmlParser.delegate = self
        
        xmlParser.parse()
        
        inputStream?.close()
    }
    
}
