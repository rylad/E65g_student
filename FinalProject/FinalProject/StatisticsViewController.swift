//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Sean Valois on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    //Labels
    @IBOutlet weak var bornLabel: UIView!
    @IBOutlet weak var livingLabel: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var diedLabel: UILabel!
    //Counts
    @IBOutlet weak var born: UILabel!
    @IBOutlet weak var living: UILabel!
    @IBOutlet weak var empty: UILabel!
    @IBOutlet weak var died: UILabel!
    
    func count(withGrid: GridProtocol) {
        var countBorn = 0
        var countLiving = 0
        var countDied = 0
        var countEmpty = 0        
        
        (0 ..< withGrid.size.rows).forEach { i in
            (0 ..< withGrid.size.cols).forEach { j in
                switch withGrid[j,i].description()
                {
                case "alive":
                    countLiving += 1
                case "born":
                    countBorn += 1
                case "died":
                    countDied += 1
                default:
                    countEmpty += 1
                }
            }
        }
        living.text = String(countLiving)
        born.text = String(countBorn)
        died.text = String(countDied)
        empty.text = String(countEmpty)
    }
    
    var engine:StandardEngine!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.mapNew()
        count(withGrid: engine.grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.count(withGrid: self.engine.grid)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
