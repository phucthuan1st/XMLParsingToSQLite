# XML Parse and SQLite with FMDB Foundation

Hey guys,

## Within this project, 

### Platform: iOS (iPhone 11 or later)
### IDE: XCode 13.1 or later

### I have 3 main class:
- ImportVC: let user choose what file to import to app, and it is rootVC
- LoadingVC: move file to /official-data directory, insert new record to SQLite db, then process to XmlVC
- XmlVC: show instanceID and instanceName that was parsed from previous parsing, showing in a table view

### I have 1 protocol: 
LoadingViewControllerProtocol: make VC which delegated it will have to able to change to XmlVC

## ImportViewControlelr:
- Allow user to choose what file need to import to DB
- Files are embedded in app bundle
- Showing all files in table view
- User can select or deselect any selection
- Press Import to import file (loading in next VC)
![ImportVC](https://github.com/phucthuan1st/XMLParsingToSQLite/blob/main/Examples/ImportVC.png)

## LoadingViewController: 
- Have an progressBar to show visually the progess, and a label for who want to see exactly what percentage are done
- On background, do copy file to /official-data, create database if not exists yet, parsingXML and insert result to db
- Delegate ImportVC to change VC
![LoadingVC](https://github.com/phucthuan1st/XMLParsingToSQLite/blob/main/Examples/LoadingVC.png)

## LoadingtViewControllerDelegate
- Extend AnyObject to make it able to be weak

## XmlViewController:
Showing ID and Name of instance in XML file, that was import and insert to DB
![XMLVC](https://github.com/phucthuan1st/XMLParsingToSQLite/blob/main/Examples/XmlVC.png)

## FileHelper:
Help to process with file and directory

## DBManager:
Manage database of app, provide create db, insert record function

## Minor Issue:
- Not yet fix layout issue on mini iOS phone
- Re-import file
