//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var gridView: GridView!

    @IBAction func step(_ sender: Any) {
        gridView.grid = gridView.grid.next()
        gridView.setNeedsDisplay()
    }
    
    
    @IBAction func reset(_ sender: Any) {
        gridView.grid = Grid(gridView.size,gridView.size)
        gridView.setNeedsDisplay()
    }
}

