//
//  Global.swift
//  BananaCart
//
//  Created by Austin McKee on 9/20/15.
//  Copyright © 2015 Austin McKee. All rights reserved.
//

import Foundation

class Global {
    static var master : MasterViewController?
    
    func setNewMaster(newMaster: MasterViewController) {
        Global.master = newMaster
    }
}