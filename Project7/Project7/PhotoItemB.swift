//
//  PhotoItemB.swift
//  Project7
//
//  Created by Claudio Carnino on 21/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa


class PhotoItemB: NSCollectionViewItem {
    
    static let itemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PhotoItemB")
    
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
    
}
