//
//  ParticleInput.swift
//  BananaCart
//
//  Created by Nova Fallen on 9/19/15.
//  Copyright © 2015 Austin McKee. All rights reserved.
//

import Foundation

class ParticleInput {
    var myPhoton : SparkDevice?
    
    init(){
        SparkCloud.sharedInstance().loginWithUser("nova.fallen@gmail.com", password: "lolcats1") { (error:NSError!) -> Void in
            if let _=error {
                print("Wrong credentials or no internet connectivity, please try again")
            }
            else {
                print("Logged in")
            }
        }
        
        SparkCloud.sharedInstance().getDevices {
            (sparkDevices:[AnyObject]!, error:NSError!) -> Void in
            if let _ = error {
                print("Check your internet connectivity")
            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    for device in devices {
                        if device.name == "Bongboy" {
                            self.myPhoton = device
                            print("Bongboy success");
                        }
                    }
                }
            }
        }
    }
    
    
    
}
