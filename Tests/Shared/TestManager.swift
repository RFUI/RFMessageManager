//
//  TestManager.swift
//  RFMessageManager
//
//  Created by BB9z on 28/03/2018.
//  Copyright © 2018 RFUI. All rights reserved.
//

import XCTest

class TestManager: XCTestCase {
    
    lazy var manager: MessageManager = {
        return MessageManager()
    }()

    override func setUp() {
        super.setUp()
        manager.reset()
    }
    
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

    func testPriority() {
        let m1 = TestMessage(identifier: "ID_1")
        m1.priority = RFMessageDisplayPriority(rawValue: 100)!
        let m2 = TestMessage(identifier: "ID_2")
        m2.priority = RFMessageDisplayPriority(rawValue: 200)!
        let m3 = TestMessage(identifier: "ID_3")
        m3.priority = .high
        let m4 = TestMessage(identifier: "ID_4")
        m4.priority = .reset

        manager.show(m1)
        manager.show(m2)
        XCTAssert(manager.displayingMessage === m1)
        XCTAssertEqual(manager.queueObjects, [m2])

        // Add high priority message should replace displayingMessage.
        manager.show(m3)
        XCTAssert(manager.displayingMessage === m3)
        XCTAssertEqual(manager.queueObjects, [m2])

        // Add reset priority message should clear queue.
        manager.show(m4)
        XCTAssert(manager.displayingMessage === m4)
        XCTAssertEqual(manager.queueObjects, [])

        // Message with higher priority should display first.
        manager.show(m1)
        manager.show(m2)
        XCTAssertEqual(manager.queueObjects, [m1, m2])
        manager.hide(manager.displayingMessage)
        XCTAssert(manager.displayingMessage === m2)
        XCTAssertEqual(manager.queueObjects, [m1])
    }

    func testUpdate() {
        let ID1 = "ID_1"
        let ID2 = "ID_2"
        let m1org = TestMessage(identifier: ID1)
        m1org.message = "org"
        let m1new = TestMessage(identifier: ID1)
        m1new.message = "new"
        let m2org = TestMessage(identifier: ID2)
        m2org.message = "org"
        let m2new = TestMessage(identifier: ID2)
        m2new.message = "new"

        manager.show(m1org)
        manager.show(m2org)
        manager.update(identifier: ID1, message: m1new)
        XCTAssertEqual(manager.displayingMessage?.message, "new")
        XCTAssert(manager.lastDisplayingMessage === m1org)
        XCTAssert(manager.lastNewMessage === m1new)

        manager.update(identifier: ID2, message: m2new)
        XCTAssertEqual(manager.queueObjects, [m2new])
        XCTAssert(manager.lastDisplayingMessage === m1org)
        XCTAssert(manager.lastNewMessage === m1new)
    }
}
