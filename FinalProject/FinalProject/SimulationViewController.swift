//
//  ViewController.swift
//  Lecture9
//
//  Created by Van Simmons on 4/3/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//
import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    

    @IBOutlet weak var gridView: XView!
    @IBOutlet weak var step: UIButton!

    var delegate: EngineDelegate?
    var engine: EngineProtocol!
    var timer: Timer?
    var json: JsonProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
        self.gridView.setNeedsDisplay()
        
        json = JsonData.mapNew()
        json.gridNames = json.updateNames()
        
        
        //json = jsonData()
        //self.json.jsonArray = json.jsonArray
        //self.json.gridNames = json.gridNames
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        engine = StandardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
        self.gridView.setNeedsDisplay()
        
        json = JsonData.mapNew()
        json.gridNames = json.updateNames()
        
        //json = jsonData()
        //self.json.jsonArray = json.jsonArray
        //self.json.gridNames = json.gridNames
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
    }
    
    
    //MARK: Button Event Handling
    @IBAction func step(_ sender: UIStepper) {
        engine.grid = engine.step()
        self.gridView.setNeedsDisplay()

    }
    
    @IBAction func reset(_ sender: UIButton) {
        engine.grid = engine.reset()
        self.gridView.setNeedsDisplay()
    }
    
    @IBAction func save(_ sender: UIButton) {
        let alert = UIAlertController(title: "Saving", message: "Grid Name?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.json.addNew(title: (textField?.text)!, contents: self.engine.aliveState)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        

    }
    
    
}

