//
//  ViewController.swift
//  Project4
//
//  Created by Claudio Carnino on 10/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa
import WebKit


extension NSTouchBarItem.Identifier {
    static let navigation = NSTouchBarItem.Identifier("com.asd.project4.navigation")
    static let enterAddress = NSTouchBarItem.Identifier("com.asd.project4.enterAddress")
    static let sharingPicker = NSTouchBarItem.Identifier("com.asd.project4.sharingPicker")
    static let adjustGrid = NSTouchBarItem.Identifier("com.asd.project4.adjustGrid")
    static let adjustRows = NSTouchBarItem.Identifier("com.asd.project4.adjustRows")
    static let adjustCols = NSTouchBarItem.Identifier("com.asd.project4.adjustCols")
}


class ViewController: NSViewController {
    
    private enum BackForwardSegmentedControlTag: Int {
        case back = 0
        case forward = 1
    }
    private enum AddRemoveSegmentedControlTag: Int {
        case add = 0
        case remove = 1
    }
    
    
    private var rowsStackView: NSStackView!
    private var selectedWebView: WKWebView! {
        willSet {
            guard let selectedWebView = selectedWebView else { return }
            selectedWebView.layer?.borderWidth = 0
            selectedWebView.layer?.borderColor = nil
        }
        didSet {
            selectedWebView.layer?.borderWidth = 4
            selectedWebView.layer?.borderColor = NSColor.blue.cgColor
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the stackview
        rowsStackView = NSStackView()
        rowsStackView.orientation = .vertical
        rowsStackView.distribution = .fillEqually
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rowsStackView)
        
        // Create the autolayout contraints to stick it to the parent's edges
        rowsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rowsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rowsStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rowsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Create the first columns stack view
        let firstWebView = makeWebView()
        let columnStackView = makeHorizontalStackView(containing: [firstWebView])
        
        // Add the column to the first row
        rowsStackView.addArrangedSubview(columnStackView)
        
        // Select the webview
        selectedWebView = firstWebView
    }
    
    
    private func makeWebView() -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true
        webView.load(URLRequest(url: URL(string: "https://apple.com")!))
        
        let gestureRecognizer = NSClickGestureRecognizer(target: self, action: #selector(webViewDoubleClicked(recognizer:)))
        gestureRecognizer.numberOfClicksRequired = 2
        webView.addGestureRecognizer(gestureRecognizer)
        
        return webView
    }
    
    
    private func makeHorizontalStackView(containing views: [NSView]) -> NSStackView {
        let stackView = NSStackView(views: views)
        stackView.distribution = .fillEqually
        return stackView
    }
    
    
    @IBAction private func urlEntered(_ sender: NSTextField) {
        guard let url = URL(string: sender.stringValue) else { return }
        selectedWebView.load(URLRequest(url: url))
    }
    
    
    @IBAction private func navigationClicked(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case BackForwardSegmentedControlTag.back.rawValue:
            selectedWebView.goBack()
            
        case BackForwardSegmentedControlTag.forward.rawValue:
            selectedWebView.goForward()
            
        default:
            assertionFailure()
        }
    }
    
    
    @IBAction private func adjustRows(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case AddRemoveSegmentedControlTag.add.rawValue:
            guard let firstRow = rowsStackView.arrangedSubviews.flatMap ({ $0 as? NSStackView }) .first else {
                assertionFailure()
                return
            }
            let columnsCount = firstRow.arrangedSubviews.count
            var webViews = [WKWebView]()
            for _ in (0 ..< columnsCount) { webViews.append(makeWebView()) }
            let newRow = makeHorizontalStackView(containing: webViews)
            rowsStackView.addArrangedSubview(newRow)
            
        case AddRemoveSegmentedControlTag.remove.rawValue:
            let rows = rowsStackView.arrangedSubviews.flatMap({ $0 as? NSStackView })
            guard rows.count > 1 else { return }
            guard let lastRow = rows.last else { return }
            rowsStackView.removeArrangedSubview(lastRow)
            lastRow.removeFromSuperview()
            selectFirstWebView()
            
        default:
            assertionFailure()
        }
    }
    
    
    @IBAction private func adjustColumns(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case AddRemoveSegmentedControlTag.add.rawValue:
            // Add a column for each row stack view
            rowsStackView.arrangedSubviews
                .flatMap { $0 as? NSStackView }
                .forEach { $0.addArrangedSubview(makeWebView()) }
            
        case AddRemoveSegmentedControlTag.remove.rawValue:
            let rows = rowsStackView.arrangedSubviews.flatMap { $0 as? NSStackView }
            let columnsCount = rows.first?.arrangedSubviews.count ?? 0
            guard columnsCount > 1 else { return }
            rows.forEach({ columns in
                guard let lastColumn = columns.arrangedSubviews.last else { return }
                columns.removeArrangedSubview(lastColumn)
                lastColumn.removeFromSuperview()
            })
            selectFirstWebView()
            
        default:
            assertionFailure()
        }
    }
    
    
    @objc private func webViewDoubleClicked(recognizer: NSClickGestureRecognizer) {
        guard let clickedWebView = recognizer.view as? WKWebView else { return }
        selectedWebView = clickedWebView
        
        guard let windowController = view.window?.windowController as? WindowController else { return }
        windowController.urlAddressTextField.stringValue = selectedWebView.url?.absoluteString ?? ""
    }
    
    
    private func selectFirstWebView() {
        guard let firstRow = rowsStackView.arrangedSubviews.flatMap({ $0 as? NSStackView }) .first,
            let firstWebView = firstRow.arrangedSubviews.flatMap({ $0 as? WKWebView }) .first
            else {
                return
        }
        selectedWebView = firstWebView
    }
    
    
    @objc private func selectURLAddress() {
        guard let windowController = view.window?.windowController as? WindowController else { return }
        windowController.window?.makeFirstResponder(windowController.urlAddressTextField)
    }
    
}


extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let windowController = view.window?.windowController as? WindowController else { return }
        windowController.urlAddressTextField.stringValue = selectedWebView.url?.absoluteString ?? ""
    }
    
}


extension ViewController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        NSApp.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        
        let touchBar = NSTouchBar()
        touchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier("com.asd.project4")
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.navigation, .adjustGrid, .enterAddress, .sharingPicker]
        touchBar.principalItemIdentifier = .enterAddress
        touchBar.customizationAllowedItemIdentifiers = [.adjustGrid, .adjustRows, .adjustCols, .sharingPicker]
        touchBar.customizationRequiredItemIdentifiers = [.enterAddress]
        return touchBar
    }
    
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .enterAddress:
            let button = NSButton(title: "Enter URL", target: self, action: #selector(selectURLAddress))
            button.setContentHuggingPriority(NSLayoutConstraint.Priority(10), for: .horizontal)
            let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
            touchBarItem.view = button
            return touchBarItem
            
        case .navigation:
            let backImage = NSImage(named: NSImage.Name.touchBarGoBackTemplate)!
            let forwardImage = NSImage(named: NSImage.Name.touchBarGoForwardTemplate)!
            let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
            touchBarItem.view = NSSegmentedControl(images: [backImage, forwardImage],
                                                   trackingMode: .momentary,
                                                   target: self,
                                                   action: #selector(navigationClicked(_:)))
            return touchBarItem
            
        case .sharingPicker:
            let touchBarItem = NSSharingServicePickerTouchBarItem(identifier: identifier)
            touchBarItem.delegate = self
            return touchBarItem
            
        case .adjustRows:
            let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
            touchBarItem.view = NSSegmentedControl(labels: ["Add row", "Remove row"],
                                                   trackingMode: .momentaryAccelerator,
                                                   target: self,
                                                   action: #selector(adjustRows(_:)))
            touchBarItem.customizationLabel = "Rows"
            return touchBarItem
            
        case .adjustCols:
            let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
            touchBarItem.view = NSSegmentedControl(labels: ["Add column", "Remove column"],
                                                   trackingMode: .momentaryAccelerator,
                                                   target: self,
                                                   action: #selector(adjustColumns(_:)))
            touchBarItem.customizationLabel = "Columns"
            return touchBarItem
            
        case .adjustGrid:
            let touchBarItem = NSPopoverTouchBarItem(identifier: identifier)
            touchBarItem.collapsedRepresentationLabel = "Grid"
            touchBarItem.customizationLabel = "Adjust grid"
            touchBarItem.popoverTouchBar = NSTouchBar()
            touchBarItem.popoverTouchBar.delegate = self
            touchBarItem.popoverTouchBar.defaultItemIdentifiers = [.adjustRows, .adjustCols]
            return touchBarItem
            
        default:
            return nil
        }
    }
    
}


extension ViewController: NSSharingServicePickerTouchBarItemDelegate {
    
    func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
        guard let url = selectedWebView.url?.absoluteString else { return [] }
        return [url]
    }
    
}
