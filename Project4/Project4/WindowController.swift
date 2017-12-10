//
//  WindowController.swift
//  Project4
//
//  Created by Claudio Carnino on 10/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet private(set) var urlAddressTextField: NSTextField!
    
    
    override func cancelOperation(_ sender: Any?) {
        window?.makeFirstResponder(contentViewController)
    }
    
}
