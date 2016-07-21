//
//  LTInputPanel.swift
//  LTInputPanel
//
//  Created by leo on 16/7/20.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit


public protocol LTCustomInputPanel {
    func requiredHeight() -> CGFloat
    func useReporter(reporter: LTInputReporter)
}

public protocol LTInputReporter: class {
    func didChoose(result: LTInputResult)
}

public class LTInputPanel: XibBasedView {
    
    enum State {
        case Keyboard
        case Panel
        case None
    }
    
    @IBOutlet weak var inputBar: UIView!
    @IBOutlet weak var inputBarBottom: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var panelContainer: UIView!
    @IBOutlet weak var panelContainerHeight: NSLayoutConstraint!
    
    var customPanel: UIView?
    var didChoose: ((result: LTInputResult) -> ())?
    var inputBarPositionChanged: ((top: CGFloat) -> ())?
    
    let borderColor = UIColor(hex: 0xcccccc)
    
    var willShowPanel = false
    var state: State = .None
    
    public override func load() {
        super.load()
        
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = borderColor.CGColor
        textView.layer.borderWidth = 0.5
        textView.delegate = self
        textView.contentInset = UIEdgeInsetsZero

        panelContainerHeight.constant = 200
        
        inputBar.layer.borderColor = borderColor.CGColor
        inputBar.layer.borderWidth = 0.5
        
       
        

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    public func registerCustomInputPanel<T: UIView where T: protocol<LTCustomInputPanel>>(panel: T) {
        customPanel = panel
        panel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        panel.frame = panelContainer.bounds
        panelContainer.addSubview(panel)
        panelContainerHeight.constant = panel.requiredHeight()
        layoutIfNeeded()
        panel.useReporter(self)
    }
    
    public func hide() {
        switch state {
        case .None:
            break
        case .Keyboard:
            textView.resignFirstResponder()
        case .Panel:
            UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseInOut], animations: {
                self.inputBarBottom.constant = 0
                self.layoutIfNeeded()
            }, completion: nil)
        }
        state = .None
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        let keyboardShowing = keyboardFrame.origin.y != UIScreen.mainScreen().bounds.height
        if willShowPanel {
            inputBarBottom.constant = panelContainerHeight.constant
        }
        else if keyboardShowing {
            inputBarBottom.constant = keyboardFrame.height
        } else {
            inputBarBottom.constant = 0
        }
        UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        switch state {
        case .None:
            UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseInOut], animations: {
                self.inputBarBottom.constant = self.panelContainerHeight.constant
                self.layoutIfNeeded()
            }, completion: nil)
            state = .Panel
        case .Keyboard:
            willShowPanel = true
            textView.resignFirstResponder()
            state = .Panel
        case .Panel:
            textView.becomeFirstResponder()
            state = .Keyboard
        }
    }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if point.y < inputBar.frame.origin.y {
            return false
        }
        return true
    }
}

extension LTInputPanel: LTInputReporter {
    public func didChoose(result: LTInputResult) {
        didChoose?(result: result)
    }
}

extension LTInputPanel: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        willShowPanel = false
        state = .Keyboard
        return true
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            didChoose(LTTextInputResult(text: textView.text))
            textView.text = ""
            textViewDidChange(textView)
            textView.resignFirstResponder()
            state = .None
            return false
        }
        return true
    }
    
    public func textViewDidChange(textView: UITextView) {
        textViewHeight.constant = max(36, textView.contentSize.height)
    }
}
