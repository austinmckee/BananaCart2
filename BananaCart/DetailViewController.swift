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

    @IBOutlet weak var Stepper: UIStepper!
    @IBAction func StepperChanged() {
        print(Stepper.value)
        Stepper.value = Double(Int(Stepper.value))
        if Stepper.value < 0.99 {
            Stepper.value = 1;
        }
        
        if detailItem != nil && master != nil {
            master!.updateQuantity(detailItem!, quantity: Int(Stepper.value))
        }
        configureView()
    }
    
    var master : MasterViewController?
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

