//
//  ViewController.swift
//  Project1
//
//  Created by Claudio Carnino on 05/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa

class ViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction private func shareImage(_ sender: NSView) {
        guard let detailViewController = childViewControllers[1] as? DetailViewController,
            let image = detailViewController.imageView.image
            else {
                return
        }
        let sharingPicker = NSSharingServicePicker(items: [image])
        sharingPicker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
    }

}

