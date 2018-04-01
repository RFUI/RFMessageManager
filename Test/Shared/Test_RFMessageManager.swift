//
//  Test_RFMessageManager.swift
//  Test-Shared
//
//  Created by BB9z on 28/03/2018.
//  Copyright © 2018 RFUI. All rights reserved.
//

import XCTest

class Test_RFMessageManager: XCTestCase {
    
    lazy var manager: RFMessageManager = {
        return RFMessageManager()
    }()
    
    func testHide() {
        let m1 = RFMessage(identifier: "ID_1")
        let m2 = RFMessage(identifier: "ID_2")
        let m3 = RFMessage(identifier: "ID_3")
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        XCTAssertEqual(manager.displayingMessage, m1)
        XCTAssertEqual(manager.queuedMessages, [m2, m3])
        
        manager.hide(m2) // in queue
        XCTAssertEqual(manager.displayingMessage, m1)
        XCTAssertEqual(manager.queuedMessages, [m3])

        manager.hide(m1) // displaying
        XCTAssertEqual(manager.displayingMessage, m3)
        XCTAssertEqual(manager.queuedMessages, [])

        manager.show(m2)
        manager.show(m1)
        XCTAssertEqual(manager.displayingMessage, m3)
        XCTAssertEqual(manager.queuedMessages, [m2, m1])

        manager.hide(nil)
        XCTAssertEqual(manager.displayingMessage, m3)
        XCTAssertEqual(manager.queuedMessages, [m2, m1])
    }
    
    func testHideWithID() {
        let m1 = RFMessage(identifier: "ID_1")
        let m2 = RFMessage(identifier: "ID_2")
        let m3 = RFMessage(identifier: "ID_3")
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        XCTAssertEqual(manager.displayingMessage, m1)
        XCTAssertEqual(manager.queuedMessages, [m2, m3])

        manager.hide(withIdentifier: "ID_1")
        XCTAssertEqual(manager.displayingMessage, m2)
        XCTAssertEqual(manager.queuedMessages, [m3])
        
        manager.hide(withIdentifier: "ID_3")
        XCTAssertEqual(manager.displayingMessage, m2)
        XCTAssertEqual(manager.queuedMessages, [])
        
        manager.show(m1)
        manager.show(m3)
        XCTAssertEqual(manager.displayingMessage, m2)
        XCTAssertEqual(manager.queuedMessages, [m1, m3])
        
        manager.hide(withIdentifier: nil)
        XCTAssertEqual(manager.displayingMessage, nil)
        XCTAssertEqual(manager.queuedMessages, [])
    }
    
    func testHideWithGroupID() {
        let m1 = RFMessage(identifier: "ID_1")
        m1.groupIdentifier = "g1"
        let m2 = RFMessage(identifier: "ID_2")
        m2.groupIdentifier = "g2"
        let m3 = RFMessage(identifier: "ID_3")
        m3.groupIdentifier = "g3"
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        print(manager)
        manager.hide(withGroupIdentifier: "g3")
        XCTAssertEqual(manager.displayingMessage, m1)
        XCTAssertEqual(manager.queuedMessages, [m2])
        
        manager.hide(withGroupIdentifier: "g1")
        XCTAssertEqual(manager.displayingMessage, m2)
        XCTAssertEqual(manager.queuedMessages, [])
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        manager.hide(withGroupIdentifier: nil)
        XCTAssertEqual(manager.displayingMessage, nil)
        XCTAssertEqual(manager.queuedMessages, [])
    }
    
    func testMultipleIdenticalIDs() {
        let m1 = RFMessage(identifier: "ID_e")
        let m2 = RFMessage(identifier: "ID_e")
        let m3 = RFMessage(identifier: "ID_e")
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        XCTAssertEqual(manager.displayingMessage, m1)
        XCTAssertEqual(manager.queuedMessages, [m2], "m3 is same to m2, so m3 not added into queue.")
        
        manager.hide(withIdentifier: "ID_e")
        XCTAssertEqual(manager.displayingMessage, nil)
        XCTAssertEqual(manager.queuedMessages, [])
    }
}
