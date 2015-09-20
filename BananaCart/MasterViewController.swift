//
//  MasterViewController.swift
//  BananaCart
//
//  Created by Austin McKee on 9/19/15.
//  Copyright © 2015 Austin McKee. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [FoodEntry]()
    
    var foodEntries : NSMutableArray = NSMutableArray()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            
            self.detailViewController?.setNewMaster(self)
        }
        
        foodEntries.addObject(FoodEntry(name: "Nestle Water", id: "0068274000218", price: 1.0, weight: 520))
        foodEntries.addObject(FoodEntry(name: "Rice Krispies", id: "0724131462178", price: 0.5, weight: 42))
        foodEntries.addObject(FoodEntry(name: "Lay's Chips", id: "0060410001639", price: 0.3, weight: 40))
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateQuantity(entry: FoodEntry, quantity: Int) {
        
        for obj : AnyObject in objects {
            let obj2 = obj as! FoodEntry
            if entry.id == obj2.id {
                print(String(format: "old: %d, new: %d", obj2.quantity, quantity))
                obj2.quantity = Int32(quantity)
                self.tableView.reloadData()
                return
            }
        }
        
    }

    func insertNewObject(obj: FoodEntry) {
        objects.insert(obj, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func recognized(data: NSString) {
        for object : AnyObject in foodEntries {
            let object = object as! FoodEntry
            if object.id == data && object.canScan() {
                object.scan()
                scan(object)
            }
        }
    }
    
    func scan(item: FoodEntry) {
        
        // See if we've already scanned
        for obj : AnyObject in objects {
            let obj2 = obj as! FoodEntry
            if item.id == obj2.id {
                obj2.quantity++
                print(String(format: "old: %d, new: %d", obj2.quantity - 1, obj2.quantity))
                self.tableView.reloadData()
                return
            }
        }
        
        // Else add a new one
        insertNewObject(item.copy())
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                controller.setNewMaster(self)
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func getTextOfFood(entry: FoodEntry) -> String {
        if entry.quantity > 1 {
            return entry.name as String + String(format: " (x%d) $%.2f", entry.quantity, entry.price)
        } else {
            return entry.name as String + String(format: " $%.2f", entry.price)
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = getTextOfFood(object)

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

