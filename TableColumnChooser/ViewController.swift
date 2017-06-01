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
        
        // set up sorting
        let ageDescriptor = NSSortDescriptor(key: "age", ascending: true)
        let familyNameDescriptor = NSSortDescriptor(key: "familyName", ascending: true,
                                                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        let givenNameDescriptor = NSSortDescriptor(key: "givenName", ascending: true,
                                                   selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        
        tableView.tableColumns[0].sortDescriptorPrototype = givenNameDescriptor
        tableView.tableColumns[1].sortDescriptorPrototype = familyNameDescriptor
        tableView.tableColumns[2].sortDescriptorPrototype = ageDescriptor
        
        
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
        
        tableView.doubleAction = #selector(doubleClick(_:))
        //or        tableView.action =
    }
    
    
    override var representedObject: Any? {
        didSet {
            if let person = representedObject as? Person {
                print(person)
                reload()
            }
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func doubleClick(_ sender:AnyObject) {
        // the sender is the tableview
        
        guard tableView.selectedRow >= 0 else {
            return
        }
        let item = dataArray[tableView.selectedRow]
        representedObject = item
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
            
            let item = tableHeaderContextMenu.addItem(withTitle: title,
                                                      action:#selector(contextMenuSelected(_:)),
                                                      keyEquivalent: "")
            
            item.target = self
            item.representedObject = column
            item.state = NSOnState
            
            if let dict = UserDefaults.standard.dictionary(forKey: kUserDefaultsKeyVisibleColumns) as? [String : Bool] {
                if let hidden = dict[column.identifier] {
                    column.isHidden = hidden
                }
            }
            item.state = column.isHidden ? NSOffState : NSOnState
            
        }
        self.tableView.headerView?.menu = tableHeaderContextMenu
    }
    
    /// The table action. `addItemWithTitle` specifies this func.
    func contextMenuSelected(_ menu:NSMenuItem) {
        if let column = menu.representedObject as? NSTableColumn {
            let shouldHide = !column.isHidden
            column.isHidden = shouldHide
            menu.state = column.isHidden ? NSOffState: NSOnState
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
            dict[column.identifier] = column.isHidden
        }
        UserDefaults.standard.set(dict, forKey: kUserDefaultsKeyVisibleColumns)
    }
    
}

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        return dataArray.count
    }
    
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let column = tableColumn {
            if let cellView = tableView.make(withIdentifier: column.identifier, owner: self) as? NSTableCellView {
                
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
    
    // or you can set the tableview's action property to something else
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let table = notification.object as? NSTableView {
            print(table.selectedRow)
        }
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        // the first sort descriptor that corresponds to the column header clicked by the user
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        if sortDescriptor.key == "age" {
            if sortDescriptor.ascending {
                self.dataArray = dataArray.sorted { $0.age < $1.age }
            } else {
                self.dataArray = dataArray.sorted { $0.age > $1.age }
            }
        }
        
        if sortDescriptor.key == "familyName" {
            if sortDescriptor.ascending {
                self.dataArray = dataArray.sorted {lhs, rhs in
                    let l = lhs.familyName.characters
                    let r = rhs.familyName.characters
                    return l.lexicographicallyPrecedes(r)
                }
            } else {
                self.dataArray = dataArray.sorted {lhs, rhs in
                    let l = lhs.familyName.characters
                    let r = rhs.familyName.characters
                    return !l.lexicographicallyPrecedes(r)
                }
            }
        }
        
        if sortDescriptor.key == "givenName" {
            if sortDescriptor.ascending {
                self.dataArray = dataArray.sorted {lhs, rhs in
                    let l = lhs.givenName.characters
                    let r = rhs.givenName.characters
                    return l.lexicographicallyPrecedes(r)
                }
            } else {
                self.dataArray = dataArray.sorted {lhs, rhs in
                    let l = lhs.givenName.characters
                    let r = rhs.givenName.characters
                    return !l.lexicographicallyPrecedes(r)
                }
            }
        }
        print("sortDescriptor.key \(String(describing: sortDescriptor.key))")
        
        reload()
        
    }
    
}
