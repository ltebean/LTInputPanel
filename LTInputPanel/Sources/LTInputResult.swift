//
//  LTInputResult.swift
//  LTInputPanel
//
//  Created by leo on 16/7/20.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import Foundation

public protocol LTInputResult {
    func getContent() -> String
}


public struct LTTextInputResult: LTInputResult {
    
    var text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public func getContent() -> String {
        return text
    }
}