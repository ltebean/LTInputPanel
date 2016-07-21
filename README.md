## Demo
![Demo](https://raw.githubusercontent.com/ltebean/LTInputPanel/master/demo.gif)


## Usage

Put the LTInputPanel(is a UIView) into the storyboard, then configure it as:

```swift
inputPanel.registerCustomInputPanel(CustomPanel(frame: CGRectZero))
inputPanel.didChoose = { result in
    print(result.getContent())
}
```

The custom panel is a UIView which must implement `LTCustomInputPanel` protocol:

```swift
public protocol LTCustomInputPanel {
    func requiredHeight() -> CGFloat
    func useReporter(reporter: LTInputReporter)
}
```

A sample custom panel:
```swift
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
```

