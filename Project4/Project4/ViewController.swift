//
//  ViewController.swift
//  Project4
//
//  Created by Claudio Carnino on 10/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa
import WebKit

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
        let columnStackView = makeHorizontalStackView(containing: [makeWebView()])
        
        // Add the column to the first row
        rowsStackView.addArrangedSubview(columnStackView)
    }
    
    
    private func makeWebView() -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true
        webView.load(URLRequest(url: URL(string: "https://apple.com")!))
        return webView
    }
    
    
    private func makeHorizontalStackView(containing views: [NSView]) -> NSStackView {
        let stackView = NSStackView(views: views)
        stackView.distribution = .fillEqually
        return stackView
    }
    
    
    @IBAction private func urlEntered(_ sender: NSTextField) {
        
    }
    
    
    @IBAction private func navigationClicked(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case BackForwardSegmentedControlTag.back.rawValue:
            break
        case BackForwardSegmentedControlTag.forward.rawValue:
            break
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
            let rows = rowsStackView.arrangedSubviews.flatMap ({ $0 as? NSStackView })
            guard rows.count > 1 else { return }
            guard let lastRow = rows.last else { return }
            rowsStackView.removeArrangedSubview(lastRow)
            lastRow.removeFromSuperview()
            
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
            
        default:
            assertionFailure()
        }
    }
    
}


extension ViewController: WKNavigationDelegate {
    
}

