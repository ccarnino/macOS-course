//
//  SourceViewController.swift
//  Project1
//
//  Created by Claudio Carnino on 05/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa

class SourceViewController: NSViewController {

    @IBOutlet var tableView: NSTableView!
    
    private var imageNames: [String] = {
        let fileManager = FileManager.default
        guard let resourcePath = Bundle.main.resourcePath,
            let resources = try? fileManager.contentsOfDirectory(atPath: resourcePath) else {
                return []
        }
        return resources.filter { $0.hasPrefix("nssl") } .sorted { $0 < $1 }
    }()
    
}


extension SourceViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return imageNames.count
    }
    
}


extension SourceViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn,
            let cellView = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView else {
                return nil
        }
        let imageName = imageNames[row]
        cellView.textField?.stringValue = imageName
        cellView.imageView?.image = NSImage(named: NSImage.Name(imageName))
        return cellView
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1,
            let parentViewController = parent as? NSSplitViewController,
            let detailViewController = parentViewController.childViewControllers[1] as? DetailViewController else {
                return
        }
        let imageName = imageNames[tableView.selectedRow]
        detailViewController.showImage(name: imageName)
    }
    
}
