//
//  ViewController.swift
//  Project7
//
//  Created by Claudio Carnino on 17/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    
    @IBOutlet private var collectionView: NSCollectionView!
    
    private let itemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Photo")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(PhotoItem.self, forItemWithIdentifier: itemIdentifier)
    }
    
}


extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: itemIdentifier, for: indexPath)
        guard let photoItem = item as? PhotoItem else { return item }
        
        photoItem.view.wantsLayer = true
        photoItem.view.layer?.backgroundColor = NSColor.red.cgColor
        
        return photoItem
    }
    
}
