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
        dataArray.append(Person(givenName: "Heidi", familyName: "Clare", age: 45))
        dataArray.append(Person(givenName: "Helen", familyName: "Back", age: 45))
        dataArray.append(Person(givenName: "Jack", familyName: "Haas", age: 33))
        dataArray.append(Person(givenName: "Justin", familyName: "Case", age: 32))
        dataArray.append(Person(givenName: "Ophelia", familyName: "Payne", age: 44))
        dataArray.append(Person(givenName: "Justin", familyName: "Case", age: 54))
        dataArray.append(Person(givenName: "Paige", familyName: "Turner", age: 55))
        dataArray.append(Person(givenName: "Rick", familyName: "O'Shea", age: 65))
        dataArray.append(Person(givenName: "Rick", familyName: "Shaw", age: 23))
        dataArray.append(Person(givenName: "Sal", familyName: "Minella", age: 11))
        dataArray.append(Person(givenName: "Seth", familyName: "Poole", age: 25))
        dataArray.append(Person(givenName: "Russell", familyName: "Leeves", age: 33))
        dataArray.append(Person(givenName: "Sonny", familyName: "Day", age: 76))
        dataArray.append(Person(givenName: "Stan", familyName: "Still", age: 69))
        dataArray.append(Person(givenName: "Stanley", familyName: "Cupp", age: 65))
        dataArray.append(Person(givenName: "Sue", familyName: "Flay", age: 54))
        dataArray.append(Person(givenName: "Tim", familyName: "Burr", age: 51))
        dataArray.append(Person(givenName: "Tommy", familyName: "Hawk", age: 27))
        dataArray.append(Person(givenName: "Warren", familyName: "Peese", age: 38))
        dataArray.append(Person(givenName: "Sue", familyName: "Scheph", age: 41))
        dataArray.append(Person(givenName: "Will", familyName: "Power", age: 42))
        dataArray.append(Person(givenName: "Woody", familyName: "Forrest", age: 62))
        dataArray.append(Person(givenName: "X.", familyName: "Benedict", age: 88))
        
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
