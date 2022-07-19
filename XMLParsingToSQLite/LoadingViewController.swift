//
//  loadingViewController.swift
//  XMLParsingToSQLite
//
//  Created by MacMini01 on 05/07/2022.
//
import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
	weak var delegate:LoadingViewControllerDelegate?
	
    @IBOutlet weak var progressingBar: UIProgressView!
	@IBOutlet weak var progressingLabel: UILabel!
	
    var elementName:String?
    var fileList = [String]()
    
    var record:Record?

    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadContent(completion: { [weak self] in
			//MARK: if delegate not weak, it will retain cycle
			self?.delegate?.changeToXMLViewController()
		})
    }
    
    func loadContent(completion: @escaping () -> ()) {
        progressingBar.setProgress(0.0, animated: true)
		progressingLabel.text = "0%"
        var progress:Float = 0.0
        
        let workItem = DispatchWorkItem {
            do {
                try self.moveFileToOfficial()
                for file in self.fileList {
                    
                    try self.handleForXMLInstace(path: file)
                    progress += 1.0 / Float(self.fileList.count)
                    
                    DispatchQueue.main.async {
                        self.progressingBar.setProgress(progress, animated: true)
						self.progressingLabel.text = "\((progress * 100).rounded())%"
                    }
                }
            }
            catch {
                self.Alert(message: error.localizedDescription)
            }
        }
        
        DispatchQueue.global().async(execute: workItem)
        workItem.notify(queue: .main, execute: completion)
        
    }
    
    func Alert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
}

extension LoadingViewController : XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "instanceID" {
            record = Record(instanceID: "", instanceName: "")
            self.elementName = elementName
        }
        if elementName == "instanceName" {
			if record == nil || record?.instanceID == "" {
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
			DBManager.shared.insertRecord(record: record!, completion: {_ in })
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

extension LoadingViewController {
    //MARK: move to FileHelper later
    func moveFileToOfficial() throws {
        let fh = FileHelper.shared
        
        if !fh.existDirectory(Path: fh.pathToDir("official-data")) {
            try fh.createDirectory(Path: fh.pathToDir("official-data"))
        }

        try fh.copyXMLFileToOfficial()
    }
    
    func handleForXMLInstace(path:String) throws {
        let fileName = path.split(separator: "/").last
        let filePath = FileHelper.shared.pathToDir("official-data") + "/" + fileName!
        
        let inputStream = InputStream(fileAtPath: filePath)
        let xmlParser = XMLParser(stream: inputStream!)

        xmlParser.delegate = self

        xmlParser.parse()

        inputStream?.close()
    }
    
}

//MARK: make Delegate extend AnyObject, so it can be a weak var
protocol LoadingViewControllerDelegate : AnyObject {
	func changeToXMLViewController()
}
