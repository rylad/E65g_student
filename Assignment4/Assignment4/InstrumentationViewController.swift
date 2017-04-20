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
    
    var engine: EngineProtocol!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rows = 5
        let cols = 5
        engine = standardEngine(rows, cols)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rowStep(_ sender: UIStepper) {
        self.rows.text = sender.value.description
    }
    
    @IBAction func colStep(_ sender: UIStepper) {
        self.cols.text = sender.value.description
    }
    
    @IBAction func timer(_ sender: UISlider) {
        engine.timerInterval = Double(sender.value)
    }
    
    


}
