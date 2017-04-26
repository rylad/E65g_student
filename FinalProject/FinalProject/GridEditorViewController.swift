//
//  GridEditor.swift
//  FinalProject
//
//  Created by Sean Valois on 4/23/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    var saveClosure: ((String)-> Void)?
    var gridName: String?
    var gridContents: [[Int]]?
    var delegate: EngineDelegate?
    var engine: EngineProtocol!
    
    @IBOutlet weak var gridView: XView!
    @IBOutlet weak var gridNameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=false
        
        if let gridName = gridName{
            gridNameTextField.text = gridName
        }
        
        if let gridContents = gridContents {
            textView.text = String(describing: gridContents)
        }
        
        engine = standardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
    
    }
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.gridRows = standardEngine.mapNew().rows
        self.gridView.gridCols = standardEngine.mapNew().cols
        self.gridView.setNeedsDisplay()
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let newValue = gridNameTextField.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


