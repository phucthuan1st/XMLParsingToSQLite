
import UIKit

class RecordCell : UITableViewCell {
    @IBOutlet weak var instanceName: UILabel!
    @IBOutlet weak var instanceID: UILabel!
}

class xmlViewController: UIViewController {

    @IBOutlet weak var recordTable: UITableView!
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTable()
        fetchRecord()
    }
}

extension xmlViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        cell.instanceID.text = records[indexPath.row].instanceID
        cell.instanceName.text = records[indexPath.row].instanceName
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func prepareTable() {
        recordTable.delegate = self
        recordTable.dataSource = self
        recordTable.allowsSelection = false
        
        recordTable.refreshControl = UIRefreshControl()
        recordTable.refreshControl?.addTarget(self, action: #selector(callRefreshTable), for: .valueChanged)
        
    }
    
    @objc func callRefreshTable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.fetchRecord()
            self.recordTable.refreshControl?.endRefreshing()
        })
    }
    
    
    func fetchRecord() {
        DBManager.shared.fetchRecord(completion: { [weak self] records in
            self?.records = records
            self?.recordTable.reloadData()
        })
    }
}
