//
//  TestNetworkActivityMessage.swift
//  RFMessageManager
//
//  Created by BB9z on 2020/2/13.
//  Copyright © 2020 RFUI. All rights reserved.
//

import XCTest

class TestNetworkActivityMessage: XCTestCase {

    lazy var manager: MessageManager = {
        return MessageManager()
    }()

    override func setUp() {
        super.setUp()
        manager.reset()
    }

    func testMessageInit() {
        let m1 = RFNetworkActivityMessage(identifier: "id", message: "text", status: .info)
        XCTAssertEqual(m1.identifier, "id")
        XCTAssertEqual(m1.message, "text")
        XCTAssertEqual(m1.status, .info)
        m1.type = "type"
        m1.modal = true
        m1.progress = 0.5
        print(m1)
    }

    func testShowMessageMethod() {
        manager.show(withMessage: "text", status: .loading, modal: true, priority: .high, autoHideAfterTimeInterval: 3, identifier: nil, groupIdentifier: nil)
        guard let msg = manager.displayingMessage as? RFNetworkActivityMessage else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(msg.message, "text")
        XCTAssertEqual(msg.status, .loading)
        XCTAssertEqual(msg.modal, true)
        XCTAssertEqual(msg.priority, .high)
        XCTAssertEqual(msg.displayDuration, 3)
        XCTAssertEqual(msg.identifier, "")
        XCTAssertEqual(msg.groupIdentifier, "")
    }

    func testShowProgressMethod() {
        manager.showProgress(0.5, message: nil, status: .downloading, modal: false, identifier: "a")
        guard let msg = manager.displayingMessage as? RFNetworkActivityMessage else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(msg.progress, 0.5)
        XCTAssertEqual(msg.message, nil)
        XCTAssertEqual(msg.status, .downloading)
        XCTAssertEqual(msg.modal, false)
        XCTAssertEqual(msg.priority, .queue)
        XCTAssertEqual(msg.displayDuration, 0)
        XCTAssertEqual(msg.identifier, "a")
        XCTAssertEqual(msg.groupIdentifier, nil)
    }

    func testAlertErrorMethod() {
        manager.alertError(message: "error string")
        guard let msg = manager.displayingMessage as? RFNetworkActivityMessage else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(msg.message, "error string")
        XCTAssertEqual(msg.status, .fail)
        XCTAssertEqual(msg.modal, false)
        XCTAssertEqual(msg.priority, .high)
        manager.hide(msg)

        manager.alertError(nil, title: "title", fallbackMessage: "fallback")
        guard let msg2 = manager.displayingMessage as? RFNetworkActivityMessage else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(msg2.message, "title\nfallback")
        manager.hide(msg2)

        manager.alertError(NSError(domain: "a", code: 0, userInfo: [NSLocalizedDescriptionKey: "this error"]), title: "title", fallbackMessage: "fallback")
        guard let msg3 = manager.displayingMessage as? RFNetworkActivityMessage else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(msg3.message, "title\nthis error")
        manager.hide(msg3)
    }
}
