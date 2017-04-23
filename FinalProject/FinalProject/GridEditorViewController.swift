//
//  GridEditor.swift
//  FinalProject
//
//  Created by Sean Valois on 4/23/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController {
    
    var fruitName: String?
    var saveClosure: ((String)-> Void)?
    
    @IBOutlet weak var fruitNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=false
        if let fruitName = fruitName {
            fruitNameTextField.text = fruitName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let newValue = fruitNameTextField.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
