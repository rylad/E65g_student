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
    var json: jsonProtocol!
    
//    var aliveState = [[Int]]()
//    var bornState = [[Int]]()
//    var diedState = [[Int]]()
//    var saveDict = [String: [[Int]]]()
//    
//    func saving(withGrid: GridProtocol){
//        (0 ..< withGrid.size.rows).forEach { i in
//            (0 ..< withGrid.size.cols).forEach { j in
//                switch withGrid[j,i].description()
//                {
//                case "alive":
//                    aliveState.append([j,i])
//                case "born":
//                    bornState.append([j,i])
//                case "died":
//                    diedState.append([j,i])
//                default:
//                    ()
//                }
//            }
//        }
//        print(aliveState)
//        print(bornState)
//        print(diedState)
//        saveDict = ["alive": aliveState, "born": bornState, "died": diedState ]
//        NotificationCenter.default.post(
//            name: NSNotification.Name(rawValue: "refresh"),
//            object:nil,
//            userInfo: saveDict);
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = standardEngine.mapNew()
        engine.delegate = self
        gridView.drawGrid = self
        self.gridView.gridRows = engine.rows
        self.gridView.gridCols = engine.cols
        self.gridView.setNeedsDisplay()
        
        json = jsonData()
        
        
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
        engine.saving(withGrid: engine.grid)
        
        let alert = UIAlertController(title: "Saving", message: "Grid Name?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.json.addNew(title: (textField?.text!)!, contents: self.engine.aliveState)
            print("--------------------------------")
            print (textField?.text, self.engine.aliveState)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        

    }
    
    
}

