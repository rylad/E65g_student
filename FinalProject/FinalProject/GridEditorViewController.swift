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
    var coordinate = [Int]()
    
    @IBOutlet weak var gridView: XView!
    @IBOutlet weak var gridNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=false
        
        if let gridName = gridName{
            gridNameTextField.text = gridName
        }
        
        engine = standardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
    
        var count = 0
        while count < (gridContents?.count)! {
            var coordinate = gridContents![count]
            var row = Int(coordinate[0])
            var col = Int(coordinate[1])
            engine.grid[row, col] = .alive
            count+=1
        }

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


