//
//  WindowController.swift
//  Project1
//
//  Created by Claudio Carnino on 10/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet private var shareButton: NSButton! {
        didSet {
            shareButton.sendAction(on: .leftMouseDown)
        }
    }
    

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
