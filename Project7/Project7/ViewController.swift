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
    
    private lazy var photosDirectoryURL: URL = {
        let fileManager = FileManager.default
        guard let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        let photosDirectoryURL = documentDirectoryURL.appendingPathComponent("SlideMark")
        let isPhotosDirectoryExisting = fileManager.fileExists(atPath: photosDirectoryURL.path)
        if !isPhotosDirectoryExisting {
            try? fileManager.createDirectory(at: photosDirectoryURL, withIntermediateDirectories: true)
        }
        return photosDirectoryURL
    }()
    
    private var photosURLs: [URL] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
    }
    
    
    private func loadPhotos() {
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(atPath: photosDirectoryURL.path) else {
            photosURLs = []
            return
        }
        let validExtensions = ["jpg", "jpeg", "png"]
        let validPhotosURLs = files.flatMap { URL(string: $0) } .filter { validExtensions.contains($0.pathExtension.lowercased()) }
        photosURLs = validPhotosURLs
    }
    
}


extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosURLs.count
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: PhotoItemB.itemIdentifier, for: indexPath)
        guard let photoItem = item as? PhotoItemB else { return item }
//        photoItem.view.wantsLayer = true
//        photoItem.view.layer?.backgroundColor = NSColor.red.cgColor
        photoItem.imageView?.image = NSImage(contentsOf: photosURLs[indexPath.item])
        return photoItem
    }
    
}
