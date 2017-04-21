//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {

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
        engine = standardEngine.mapNew()
        rowStep.value = Double(engine.rows)
        self.rows.text = "\(engine.rows)"
        colStep.value = Double(engine.cols)
        self.cols.text = "\(engine.cols)"
        toggleOn.setOn(false, animated: false)
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
        engine.refreshRate = Double(Double(sender.value))
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

}
