//
//  DetailViewController.swift
//  Project1
//
//  Created by Claudio Carnino on 05/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {

    @IBOutlet var imageView: NSImageView!
    
    
    func showImage(name: String) {
        imageView.image = NSImage(named: NSImage.Name(name))
    }
    
}
