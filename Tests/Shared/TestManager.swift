//
//  TestManager.swift
//  RFMessageManager
//
//  Created by BB9z on 28/03/2018.
//  Copyright © 2018 RFUI. All rights reserved.
//

import XCTest

class TestManager: XCTestCase {
    
    lazy var manager: RFMessageManager = {
        return RFMessageManager()
    }()
    
    func testHide() {
        let m1 = TestMessage(identifier: "ID_1")
        let m2 = TestMessage(identifier: "ID_2")
        let m3 = TestMessage(identifier: "ID_3")
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        XCTAssert(manager.displayingMessage === m1)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m2, m3])
        
        manager.hide(m2) // in queue
        XCTAssert(manager.displayingMessage === m1)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m3])

        manager.hide(m1) // displaying
        XCTAssert(manager.displayingMessage === m3)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [])

        manager.show(m2)
        manager.show(m1)
        XCTAssert(manager.displayingMessage === m3)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m2, m1])

        manager.hide(nil)
        XCTAssert(manager.displayingMessage === m3)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m2, m1])
    }
    
    func testHideWithID() {
        let m1 = TestMessage(identifier: "ID_1")
        let m2 = TestMessage(identifier: "ID_2")
        let m3 = TestMessage(identifier: "ID_3")
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        XCTAssert(manager.displayingMessage === m1)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m2, m3])

        manager.hide(withIdentifier: "ID_1")
        XCTAssert(manager.displayingMessage === m2)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m3])
        
        manager.hide(withIdentifier: "ID_3")
        XCTAssert(manager.displayingMessage === m2)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [])
        
        manager.show(m1)
        manager.show(m3)
        XCTAssert(manager.displayingMessage === m2)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m1, m3])
        
        manager.hideAll()
        XCTAssert(manager.displayingMessage == nil)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [])
    }
    
    func testHideWithGroupID() {
        let m1 = TestMessage(identifier: "ID_1")
        m1.groupIdentifier = "g1"
        let m2 = TestMessage(identifier: "ID_2")
        m2.groupIdentifier = "g2"
        let m3 = TestMessage(identifier: "ID_3")
        m3.groupIdentifier = "g3"
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        print(manager)
        manager.hide(withGroupIdentifier: "g3")
        XCTAssert(manager.displayingMessage === m1)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m2])
        
        manager.hide(withGroupIdentifier: "g1")
        XCTAssert(manager.displayingMessage === m2)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [])
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        manager.hideAll()
        XCTAssert(manager.displayingMessage == nil)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [])
    }
    
    func testMultipleIdenticalIDs() {
        let m1 = TestMessage(identifier: "ID_e")
        let m2 = TestMessage(identifier: "ID_e")
        let m3 = TestMessage(identifier: "ID_e")
        
        manager.show(m1)
        manager.show(m2)
        manager.show(m3)
        XCTAssert(manager.displayingMessage === m1)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [m2, m3])
        
        manager.hide(withIdentifier: "ID_e")
        XCTAssert(manager.displayingMessage == nil)
        XCTAssertEqual(manager.queuedMessages as! [TestMessage], [])
    }
}
