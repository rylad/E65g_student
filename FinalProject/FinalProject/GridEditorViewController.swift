//
//  GridEditor.swift
//  FinalProject
//
//  Created by Sean Valois on 4/23/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    var saveClosure: ((String, [[Int]])-> Void)?
    var gridName: String?
    var gridContents: [[Int]]?
    var delegate: EngineDelegate?
    var engine: EngineProtocol!
    var coordinate = [Int]()
    var json: JsonProtocol!
    
    @IBOutlet weak var gridView: XView!
    @IBOutlet weak var gridNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=false

        if let gridName = gridName{
            gridNameTextField.text = gridName
        }
        
        engine = StandardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
        
        //json=jsonData()
    
        var count = 0
        while count < (gridContents?.count)! {
            var coordinate = gridContents![count]
            let row = Int(coordinate[0])
            let col = Int(coordinate[1])
            engine.grid[row, col] = .alive
            count+=1
            engineDidUpdate(withGrid: engine.grid)
        }

    }
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.gridRows = StandardEngine.mapNew().rows
        self.gridView.gridCols = StandardEngine.mapNew().cols
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
    

    @IBAction func save(_ sender: UIBarButtonItem) {
        let gContents = engine.saving(withGrid: engine.grid)
        let alive = gContents["alive"]
        if let gName = gridNameTextField.text,

        let saveClosure = saveClosure {
            saveClosure(gName, alive!)
            self.navigationController?.popViewController(animated: true)
        }
        
    
    }
}


