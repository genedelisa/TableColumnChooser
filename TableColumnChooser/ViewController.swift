//
//  ViewController.swift
//  TableColumnChooser
//
//  Created by Gene De Lisa on 7/9/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!
    
    /// just a goofy data example
    struct Person {
        var givenName:String
        var familyName:String
        var age = 0
        
        init(givenName:String, familyName:String, age:Int) {
            self.givenName = givenName
            self.familyName = familyName
            self.age = age
        }
    }
    
    /// the data for the table
    var dataArray = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create some people
        dataArray.append(Person(givenName: "Noah", familyName: "Vale", age: 72))
        dataArray.append(Person(givenName: "Sarah", familyName: "Yayvo", age: 29))
        dataArray.append(Person(givenName: "Shanda", familyName: "Lear", age: 45))
        
        // set up colmn choosing
        self.createTableContextMenu()
    }

    override var representedObject: AnyObject? {
        didSet {
        }
    }

    // MARK: - Table column choosing

    /// the key in user defaults
    let kUserDefaultsKeyVisibleColumns = "kUserDefaultsKeyVisibleColumns"

    /// set up the table header context menu for choosing the columns.
    func createTableContextMenu() {
        
        let tableHeaderContextMenu = NSMenu(title:"Select Columns")
        let tableColumns = self.tableView.tableColumns
        for column in tableColumns {
            let title = column.headerCell.title
            
            if let item = tableHeaderContextMenu.addItemWithTitle(title,
                action:"contextMenuSelected:",
                keyEquivalent: "") {
                    
                    item.target = self
                    item.representedObject = column
                    item.state = NSOnState
                    
                    if let dict = NSUserDefaults.standardUserDefaults().dictionaryForKey(kUserDefaultsKeyVisibleColumns) as? [String : Bool] {
                        if let hidden = dict[column.identifier] {
                            column.hidden = hidden
                        }
                    }
                    item.state = column.hidden ? NSOffState : NSOnState
            }
        }
        self.tableView.headerView?.menu = tableHeaderContextMenu
    }
    
    /// The table action. `addItemWithTitle` specifies this func.
    func contextMenuSelected(menu:NSMenuItem) {
        if let column = menu.representedObject as? NSTableColumn {
            let shouldHide = !column.hidden
            column.hidden = shouldHide
            menu.state = column.hidden ? NSOffState: NSOnState
            if shouldHide {
                // haven't decided which I like better.
//                tableView.sizeLastColumnToFit()
                tableView.sizeToFit()
            } else {
                tableView.sizeToFit()
            }
        }
        self.saveTableColumnDefaults()
    }
    
    /// Writes the selection to user defaults. Called every time an item is chosen.
    func saveTableColumnDefaults() {
        var dict = [String : Bool]()
        let tableColumns = self.tableView.tableColumns
        for column:NSTableColumn in tableColumns {
            dict[column.identifier] = column.hidden
        }
        NSUserDefaults.standardUserDefaults().setObject(dict, forKey: kUserDefaultsKeyVisibleColumns)
    }
    


}

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return dataArray.count
    }
    
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let column = tableColumn {
            if let cellView = tableView.makeViewWithIdentifier(column.identifier, owner: self) as? NSTableCellView {
                
                let person = dataArray[row]
                
                if column.identifier == "givenName" {
                    cellView.textField?.stringValue = "\(person.givenName)"
                    return cellView
                }
                if column.identifier == "familyName" {
                    cellView.textField?.stringValue = "\(person.familyName)"
                    return cellView
                }
                if column.identifier == "age" {
                    cellView.textField?.stringValue = "\(person.age)"
                    return cellView
                }
                
                return cellView
            }
        }
        return nil
    }
    
}
