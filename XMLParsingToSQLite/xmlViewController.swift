
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
        print(records.count)
        prepareTable()
        getRecord()
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
    }
    
    func getRecord() {
        records = DBManager.shared.loadRecord()
    }
}
