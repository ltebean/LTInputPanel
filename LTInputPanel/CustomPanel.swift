//
//  CustomPanel.swift
//  LTInputPanel
//
//  Created by leo on 16/7/20.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

class CustomPanel: XibBasedView, LTCustomInputPanel {
    
    weak var reporter: LTInputReporter!
    
    func requiredHeight() -> CGFloat {
        return 120
    }
    
    func useReporter(reporter: LTInputReporter) {
        self.reporter = reporter
    }
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        reporter.didChoose(LTTextInputResult(text: "photo"))
    }
    
    @IBAction func videoButtonPressed(sender: AnyObject) {
        reporter.didChoose(LTTextInputResult(text: "video"))
    }
}
