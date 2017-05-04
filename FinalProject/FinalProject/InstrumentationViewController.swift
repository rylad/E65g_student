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
    
    var engine: EngineProtocol!
    var json: JsonProtocol!
    var gridNames: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.mapNew()
        rowStep.value = Double(engine.rows)
        self.rows.text = "\(engine.rows)"
        colStep.value = Double(engine.rows)
        self.cols.text = "\(engine.rows)"
        toggleOn.setOn(false, animated: false)
        
        json = JsonData.mapNew()
        json.parse()
        
        //Allowing time for fetcher
        sleep(3)
        
        json.gridNames = json.updateNames()
        
        sleep(3)
        //gridNames = json.updateNames()

        
        }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=true
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Row Updating
    @IBAction func rowStep(_ sender: UIStepper) {
        let numberRows = Int(sender.value)
        rows.text = String(numberRows)
        StandardEngine.mapNew().updateRows(row: numberRows)

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
        StandardEngine.mapNew().updateRows(row: value)
    }
    
    //MARK: Col updating
    @IBAction func colStep(_ sender: UIStepper) {
        let numberCols = Int(sender.value)
        cols.text = String(numberCols)
        StandardEngine.mapNew().updateCols(col: numberCols)

    }
    
    @IBAction func colText(_ sender: UITextField) {
        guard let entry = sender.text else { return }
        guard let value = Int(entry) else {
            showErrorAlert(withMessage: "\(entry) is not a valid entry, please try again. (positive numbers only)") {
                sender.text = "\(self.engine.grid.size.rows)"
            }
            return
        }
        colStep.value = Double(value)
        StandardEngine.mapNew().updateRows(row: value)
    }
    
    //MARK: Misc button handling
    @IBAction func refreshRate(_ sender: UISlider) {
        engine.refreshTimer?.invalidate()
        engine.refreshRate = Double(sender.value)
    }

    @IBAction func toggleOn(_ sender: UISwitch) {
        StandardEngine.mapNew().toggleOn(on: toggleOn.isOn)
    }
    
    @IBAction func addGrid(_ sender: UIButton) {
        json.addGrid()
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    
    
    //MARK: Table Views
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.gridNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.item % 2 == 0 ? "basic" : "gray"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = json.gridNames[indexPath.item]
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.item
            json.gridNames.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.reloadData()
        }
    }
    
    
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
        let cancelButton = UIBarButtonItem()
        cancelButton.title = "Cancel"
        navigationItem.backBarButtonItem = cancelButton
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath{
            let gridEditorController = segue.destination as! GridEditorViewController

            gridEditorController.gridName = self.json.gridNames[indexPath.item]
            gridEditorController.gridContents = self.json.getContents(index: indexPath.item)
            let maxSize = json.findMax(contents: self.json.getContents(index: indexPath.item))
            if maxSize == 0 {
                StandardEngine.mapNew().updateCols(col: engine.cols)
                StandardEngine.mapNew().updateRows(row: engine.rows)
            } else {
            StandardEngine.mapNew().updateCols(col: (maxSize)*2)
            StandardEngine.mapNew().updateRows(row: (maxSize)*2)
            }
            gridEditorController.saveClosure = {gName, alive in

                self.json.jsonArray[indexPath.item]=["title" : gName, "contents":alive]
                self.json.gridNames[indexPath.item] = gName
                //self.gridNames = self.json.updateNames()
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        
            
            
        }
    }
}
