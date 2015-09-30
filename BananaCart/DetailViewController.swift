//
//  DetailViewController.swift
//  BananaCart
//
//  Created by Austin McKee on 9/19/15.
//  Copyright © 2015 Austin McKee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var FoodLabel: UILabel!
    @IBOutlet weak var FoodQuantity: UILabel!
    @IBOutlet weak var FoodPrice: UILabel!
    @IBOutlet weak var FoodTotal: UILabel!
    @IBOutlet weak var CurrentWeight: UILabel!

    @IBOutlet weak var FoodPlease: UILabel!
    @IBOutlet weak var Stepper: UIStepper!
    @IBAction func StepperChanged() {
        print(Stepper.value)
        Stepper.value = Double(Int(Stepper.value))
        if Stepper.value < 0.99 {
            Stepper.value = 1;
        }
        
        if detailItem != nil && master != nil {
            master!.updateQuantity(detailItem!, quantity: Int(Stepper.value))
            master!.setTotal()
        }
        configureView()
    }
    
    var master : MasterViewController?
    var timer : NSTimer?
    
    var startWeight : Int = 0
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var detailItem: FoodEntry? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func setNewMaster(newMaster: MasterViewController){
        master = newMaster
    }
    
    func pleasePlace() {
        FoodPlease.text = "Please place item in cart"
        FoodPlease.textColor = UIColor.redColor()
        print("place")
    }
    func pleaseSuccess() {
        FoodPlease.text = "Success"
        FoodPlease.textColor = UIColor.greenColor()
        print("success")
    }
    
    func updateWeight() {
        if master != nil {
            self.CurrentWeight.text = String(format: "%d", master!.myWeight)
            if startWeight == 0 {
                startWeight = master!.myWeight
            } else {
                if master!.myWeight - startWeight > 200 {
                    pleaseSuccess()
                }
            }
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            if let label = self.detailDescriptionLabel {
                label.text = detail.name as String
            }
        }
        
        if let product : FoodEntry = self.detailItem {
            if self.FoodLabel != nil && self.FoodQuantity != nil && self.FoodTotal != nil {
                self.FoodLabel.text = String(product.name)
                self.FoodQuantity.text = String(product.quantity)
                self.FoodPrice.text = String(format: "$%.2f", product.price)
                self.FoodTotal.text = String(format: "$%.2f", Double(product.quantity) * product.price)
                self.Stepper.value = Double(product.quantity)
            }
            pleasePlace()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        // aasdf
        for child in childViewControllers {
            let child = child as UIViewController
            if child is CameraViewController {
                let camChild = child as! CameraViewController
                if master != nil {
                    camChild.newMaster(master!)
                }
            }
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateWeight", userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

