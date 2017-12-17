//
//  PhotoItem.swift
//  Project7
//
//  Created by Claudio Carnino on 17/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa


class PhotoItem: NSCollectionViewItem {
    
    private let selectedBorderWidth: CGFloat = 3
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? selectedBorderWidth : 0
        }
    }
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            switch (highlightState, isSelected) {
            case (.forSelection, _):
                view.layer?.borderWidth = selectedBorderWidth
            case (_, !isSelected):
                view.layer?.borderWidth = 0
            default:
                break
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
