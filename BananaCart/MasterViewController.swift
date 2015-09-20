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
    
    var loggedIn : Bool = false
    var myPhoton : SparkDevice?
    var myWeight : Int = 0
    
    var weightTimer : NSTimer?
    
    var foodEntries : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.master = self
        
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
        
        particleLogin()
        self.weightTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getWeight", userInfo: nil, repeats: true)
        
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
        var i : Int = 0
        for obj : AnyObject in objects {
            let obj2 = obj as! FoodEntry
            if item.id == obj2.id {
                obj2.quantity++
                print(String(format: "old: %d, new: %d", obj2.quantity - 1, obj2.quantity))
                self.tableView.reloadData()
                
                setTotal()
                
                tableView.selectRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
                manuallySegue()
                return
            }
            i++
        }
        
        // Else add a new one
        insertNewObject(item.copy())
        setTotal()
        tableView.selectRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        manuallySegue()
        
    }
    
    func setTotal() {
        MasterTitle.title = String(format: "Total: $%.2f", getTotal())
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                
                var controller : DetailViewController?
                if segue.destinationViewController is DetailViewController {
                    controller = segue.destinationViewController as! DetailViewController
                } else {
                    controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                }
                
                controller!.setNewMaster(self)
                controller!.detailItem = object
                controller!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller!.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func manuallySegue() {
        self.prepareForSegue(UIStoryboardSegue.init(identifier: "showDetail", source: self, destination: self.detailViewController!), sender: self);
    }
    
    func getDevice() {
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]!, error:NSError!) -> Void in
            if let e = error {
                print("Check your internet connectivity")
            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    for device in devices {
                        if device.name == "Bongboy" {
                            print("device got")
                            self.myPhoton = device
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var MasterTitle: UINavigationItem!
    
    func weightGot(weight: Int) {
        self.myWeight = weight
        print("weight got")
    }
    
    func getWeight() {
        print("getting weight")
        if self.loggedIn && self.myPhoton != nil {
            myPhoton!.getVariable("sumForces", completion: { (result:AnyObject!, error:NSError!) -> Void in
                if let e=error {
                    print(e.localizedDescription)
                    return
                }
                else {
                    if let weight = result as? Int {
                        self.weightGot(weight)
                    }
                }
            })
        }
    }
    
    func particleLogin() {
        SparkCloud.sharedInstance().loginWithUser(Secrets.sparkUsername, password: Secrets.sparkPassword) { (error:NSError!) -> Void in
            if let e=error {
                print("Wrong credentials or no internet connectivity, please try again")
                self.showAlert("Could not connect to Particle")
            }
            else {
                print("Logged in")
                self.loggedIn = true
                self.getDevice()
            }
        }
    }
    
    func getTotal() -> Double {
        var total : Double = 0.0
        for obj : AnyObject in objects {
            let obj2 = obj as! FoodEntry
            total += Double(obj2.quantity) * obj2.price
        }
        return total
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "iOScreator", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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
            setTotal()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

