//
//  ViewController.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tbl_folders: UITableView!
    private var directoriesList:[(URL,String)]=[]
    private var directoryWatcher:DirectoryMonitor?
    private let documentsDirectory = Constants.baseInternalFolder!
    private let cellIdentifier = "cellIdentifier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateFileList()
      
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        self.startMonitoring(foUrl: documentsDirectory, start: true)
    }

    func startMonitoring(foUrl:URL,start:Bool){
        if (directoryWatcher != nil){
            do {
                try directoryWatcher?.stopObserving()
            }
            catch  {
                print(error)
            }
        }
        if (start){
            directoryWatcher = DirectoryMonitor.init(pathToWatch: foUrl as NSURL, callback: {(notification:DirectoryMonitor.ChangeNotification) in
                if notification.changeType == .Added || notification.changeType == .Deleted {
                    self.updateFileList()
                }
                print("Directory contents have changed",notification)
            })
        
            do {
                try directoryWatcher?.startObserving()
            
            }
            catch  {
                print(error)
            }
        
                }

        
        
    }
    
    func updateFileList(){
        directoriesList = INFileManager.getFiles(aturl: documentsDirectory)
        tbl_folders.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: TableView delegate -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directoriesList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tblcell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if tblcell == nil {
            tblcell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        tblcell.textLabel?.text = directoriesList[indexPath.row].1
        return tblcell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
      //  showActiveNotification(title: "Full Path!", text: directoriesList[indexPath.row].0.path)
    }
}

extension ViewController {
    
   //Get all files of the root folder
   private func getSubdirectories(aturl:URL)->[(URL,String)]{
        var results:[(URL,String)]=[]
        results.append((aturl,aturl.lastPathComponent))
       let resourceKeys : [URLResourceKey] = [.creationDateKey,.isDirectoryKey]
        do {
            
            let enumerator = FileManager.default.enumerator(at: aturl,
                                                            includingPropertiesForKeys: resourceKeys,
                                                            options: [.skipsHiddenFiles,], errorHandler: { (url, error) -> Bool in
                                                                print("directoryEnumerator error at \(url): ", error)
                                                                return true
            })!
            
            let rootpathcount:[String]=aturl.pathComponents;
            for case let fileURL as URL in enumerator {
                
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                if (!resourceValues.isDirectory!){
                    
                    let tmppathcount:[String]=fileURL.pathComponents;
                    let header=String(repeating: "   ", count: (tmppathcount.count-rootpathcount.count))
                    results.append((fileURL,header+fileURL.lastPathComponent))
                    print(header+fileURL.lastPathComponent)
                }
                
            }
        } catch {
            print(error)
        }
       
        return results
    }
    
}
