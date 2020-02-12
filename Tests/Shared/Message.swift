//
//  TestMessage.swift
//  RFMessageManager
//
//  Created by BB9z on 2019/4/29.
//  Copyright © 2019 RFUI. All rights reserved.
//

import Foundation

class TestMessage: NSObject,
    RFMessage
{
    var identifier: String
    
    var groupIdentifier: String?
    
    var type: String?
    
    var message: String?
    
    var priority: RFMessageDisplayPriority = .queue
    
    init(identifier: String) {
        self.identifier = identifier
    }
}
