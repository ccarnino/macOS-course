//
//  ViewController.swift
//  Project6
//
//  Created by Claudio Carnino on 17/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        createVFL()
//        createAnchors()
//        createStackView()
        createGridView()
    }
    
    
    private func makeView(number: Int) -> NSView {
        let newView = NSTextField(labelWithString: "View #\(number)")
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.alignment = .center
        newView.wantsLayer = true
        newView.layer?.backgroundColor = NSColor.cyan.cgColor
        return newView
    }
    
    
    private func createVFL() {
        let subviews = ["view0": makeView(number: 0),
                        "view1": makeView(number: 1),
                        "view2": makeView(number: 2),
                        "view3": makeView(number: 3)]
        
        for (subviewName, subview) in subviews {
            // Add each subview and stick it to the later sides
            view.addSubview(subview)
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(subviewName)]|",
                options: [],
                metrics: nil,
                views: subviews)
            view.addConstraints(constraints)
        }
        
        // Stick them all on top of each other
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view0(40)]-(8)-[view1(40)]-(8)-[view2(40)]-(8)-[view3(40)]|",
            options: [],
            metrics: nil,
            views: subviews)
        view.addConstraints(constraints)
    }
    
    
    private func createAnchors() {
        
        let subviews = [makeView(number: 0),
                        makeView(number: 1),
                        makeView(number: 2),
                        makeView(number: 3)]
        var previousView: NSView? = nil

        for subview in subviews {
            // Add each subview and stick it to the later sides
            view.addSubview(subview)
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

            // Stick them all on top of each other
            if let previousView = previousView {
                subview.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8).isActive = true
            } else {
                subview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            }

            previousView = subview

            subview.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        }

        // Stick the last view to the bottom of the screen
        guard let lastView = subviews.last else { fatalError() }
        lastView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    private func createStackView() {
        
        let stackView = NSStackView(views: [makeView(number: 0),
                                            makeView(number: 1),
                                            makeView(number: 2),
                                            makeView(number: 3)])
        stackView.orientation = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.views.forEach { subview in
            subview.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .horizontal)
            subview.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .vertical)
        }
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    private func createGridView() {
        
        let empty = NSGridCell.emptyContentView
        
        let gridView = NSGridView(views: [
            [makeView(number: 0)],
            [makeView(number: 1), empty, makeView(number: 2)],
            [empty, empty, makeView(number: 3)],
            [makeView(number: 4), makeView(number: 5), makeView(number: 6)],
            ])
        
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        (0 ..< gridView.numberOfColumns).forEach { indexColumn in
            gridView.column(at: indexColumn).width = 128
        }
        (0 ..< gridView.numberOfRows).forEach { indexRow in
            gridView.row(at: indexRow).height = 32
        }
        
        (0 ..< gridView.numberOfColumns).forEach { indexColumn in
            (0 ..< gridView.numberOfRows).forEach { indexRow in
                let cell = gridView.cell(atColumnIndex: indexColumn, rowIndex: indexRow)
                cell.contentView?.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .horizontal)
                cell.contentView?.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .vertical)
            }
        }
        
        gridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}
