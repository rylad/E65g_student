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
    @IBOutlet weak var sizeStepper: UIStepper!
    
    var engine: EngineProtocol!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let size = gridView.gridSize
//        engine = standardEngine(rows: size, cols: size, refreshRate: Double)
        engine = standardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
        
//        sizeStepper.value = Double(engine.grid.size.rows)
//        let nc = NotificationCenter.default
//        let name = Notification.Name(rawValue: "EngineUpdate")
//        nc.addObserver(
//            forName: name,
//            object: nil,
//            queue: nil) { (n) in
//                self.gridView.setNeedsDisplay()
//        }
        
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Stepper Event Handling
    @IBAction func step(_ sender: UIStepper) {
        engine.grid = engine.grid.next()
        gridView.setNeedsDisplay()
    }
    
    //MARK: AlertController Handling
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

