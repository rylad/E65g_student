//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    

//MARK: DELETE ME TEST DATA
    var sectionHeaders = [
        "One", "Two", "Three", "Four", "Five", "Six"
    ]
    
    var data = [
        [
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date"
        ],
        [
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana"
        ],
        [
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry"
        ],
        [
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Apple",
            "Banana",
            "Cherry",
            "Date",
            "Kiwi",
            "Blueberry"
        ]
    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.item % 2 == 0 ? "basic" : "gray"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = data[indexPath.section][indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newData = data[indexPath.section]
            newData.remove(at: indexPath.row)
            data[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
//MARK: Real Stuff
    @IBOutlet weak var rows: UITextField!
    @IBOutlet weak var cols: UITextField!
    @IBOutlet weak var rowStep: UIStepper!
    @IBOutlet weak var colStep: UIStepper!
    @IBOutlet weak var refreshRate: UISlider!
    @IBOutlet weak var toggleOn: UISwitch!
    
    var engine: EngineProtocol!
//    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=true
        engine = standardEngine.mapNew()
        rowStep.value = Double(engine.rows)
        self.rows.text = "\(engine.rows)"
        colStep.value = Double(engine.cols)
        self.cols.text = "\(engine.cols)"
        toggleOn.setOn(false, animated: false)
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
        if let indexPath = indexPath {
            let fruitName = data[indexPath.section][indexPath.row]
            if let vc = segue.destination as? GridEditorViewController {
                vc.fruitName = fruitName
                vc.saveClosure = { newValue in
                    self.data[indexPath.section][indexPath.row] = newValue
                    self.tableView.reloadData()
                }
            }
        }
    }
}
