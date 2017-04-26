//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
//MARK: Real Stuff
    @IBOutlet weak var rows: UITextField!
    @IBOutlet weak var cols: UITextField!
    @IBOutlet weak var rowStep: UIStepper!
    @IBOutlet weak var colStep: UIStepper!
    @IBOutlet weak var refreshRate: UISlider!
    @IBOutlet weak var toggleOn: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    
    var gridTypes = [String]()
    var gridContents = [[Int]]()
    var jsonContent = NSArray()
    var engine: EngineProtocol!

    class gridTypes2{
        var gName: String
        var gContents: [[Int]]
        
        init(gName: String, gContents: [[Int]]){
            self.gName = gName
            self.gContents = gContents
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=true
        engine = standardEngine.mapNew()
        rowStep.value = Double(engine.rows)
        self.rows.text = "\(engine.rows)"
        colStep.value = Double(engine.cols)
        self.cols.text = "\(engine.cols)"
        toggleOn.setOn(false, animated: false)

        
        
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            
            let jsonArray = json as! NSArray
            self.jsonContent = jsonArray
            var count = 0
            while count < jsonArray.count {
                let jsonDictionary = jsonArray[count] as! NSDictionary
                let jsonTitle = jsonDictionary["title"] as! String
                self.gridTypes.append(jsonTitle)
                count+=1
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
            
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=true
    

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Row Updating
    @IBAction func rowStep(_ sender: UIStepper) {
        let numberRows = Int(sender.value)
        rows.text = String(numberRows)
        standardEngine.mapNew().updateRows(row: numberRows)

    }
    
    @IBAction func rowText(_ sender: UITextField) {
        guard let entry = sender.text else { return }
        guard let value = Int(entry) else {
            showErrorAlert(withMessage: "\(entry) is not a valid entry, please try again. (positive numbers only)") {
                sender.text = "\(self.engine.grid.size.rows)"
            }
            return
        }
        rowStep.value = Double(value)
        standardEngine.mapNew().updateRows(row: value)
    }
    
    //MARK: Col updating
    @IBAction func colStep(_ sender: UIStepper) {
        let numberCols = Int(sender.value)
        cols.text = String(numberCols)
        standardEngine.mapNew().updateCols(col: numberCols)

    }
    
    @IBAction func colText(_ sender: UITextField) {
        guard let entry = sender.text else { return }
        guard let value = Int(entry) else {
            showErrorAlert(withMessage: "\(entry) is not a valid entry, please try again. (positive numbers only)") {
                sender.text = "\(self.engine.grid.size.cols)"
            }
            return
        }
        colStep.value = Double(value)
        standardEngine.mapNew().updateCols(col: value)
    }
    
    //MARK: Misc button handling
    @IBAction func refreshRate(_ sender: UISlider) {
        engine.refreshTimer?.invalidate()
        engine.refreshRate = Double(sender.value)
    }

    @IBAction func toggleOn(_ sender: UISwitch) {
        standardEngine.mapNew().toggleOn(on: toggleOn.isOn)
    }
    
    
    //MARK: Table Views
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gridTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.item % 2 == 0 ? "basic" : "gray"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        
//        OperationQueue.main.addOperation(
        label.text = gridTypes[indexPath.item]
//        )
        return cell
    }

    //MARK: Comeback and update this
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var newData = data[indexPath.section]
//            newData.remove(at: indexPath.row)
//            data[indexPath.section] = newData
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
//        }
//    }
    
    
    //MARK: Error Handling
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Segue Handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath{
                let gridEditorController = segue.destination as! GridEditorViewController
            
                let jsonDictionary = jsonContent[indexPath.item] as! NSDictionary
                let jsonTitle = jsonDictionary["title"] as! String
                let jsonContents = jsonDictionary["contents"] as! [[Int]]
                let gridInfo : gridTypes2 = gridTypes2(gName: jsonTitle, gContents: jsonContents)
                gridEditorController.gridName = gridInfo.gName
                gridEditorController.gridContents = gridInfo.gContents
                let maxSize = gridInfo.gContents.flatMap{return $0}.max()
                standardEngine.mapNew().updateCols(col: (maxSize)!*2)
                standardEngine.mapNew().updateRows(row: (maxSize)!*2)
            
            
            
        }
    }
}
