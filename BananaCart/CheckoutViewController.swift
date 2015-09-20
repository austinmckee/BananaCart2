//
//  CheckoutViewController.swift
//  BananaCart
//
//  Created by Austin McKee on 9/20/15.
//  Copyright © 2015 Austin McKee. All rights reserved.
//

import Foundation
import UIKit

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var webs: UIWebView!
    var master : MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Global.master != nil {
            let temp : String = String(format: "http://bananacart.me/braintree/?cost=%.2f", Global.master!.getTotal())
            webs.loadRequest(NSURLRequest.init(URL: NSURL(string: temp)!))
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNewMaster(newMaster : MasterViewController?) {
        master = newMaster
    }
}