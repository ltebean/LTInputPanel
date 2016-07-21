//
//  ViewController.swift
//  LTInputPanel
//
//  Created by leo on 16/7/20.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputPanel: LTInputPanel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputPanel.registerCustomInputPanel(CustomPanel(frame: CGRectZero))
        
        inputPanel.didChoose = { result in
            print(result.getContent())
        }
    }

    @IBAction func hideButtonPressed(sender: AnyObject) {
        inputPanel.hide()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

