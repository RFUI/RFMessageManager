//
//  Test_RFMessage.swift
//  Test-iOS
//
//  Created by BB9z on 28/03/2018.
//  Copyright © 2018 RFUI. All rights reserved.
//

import XCTest

class Test_RFMessage: XCTestCase {
    func testCreateWithConfig() {
        do {
            let msg = try RFMessage { m in
                
            }
            XCTAssertNil(msg)
        } catch {
            XCTAssert((error as NSError).code > 0)
            XCTAssertNotNil(error)
        }
        
        let msg = try? RFMessage { m in
            m.identifier = "zz"
        }
        XCTAssertNotNil(msg)
    }
    
    func testCreateWithInit() {
        let msg1 = RFMessage(identifier: "zz")
        XCTAssertNotNil(msg1)
        
//        let msg2 = RFMessage()
//        XCTAssertNotNil(msg2, "It's not be nil, but will throw an NSInternalInconsistencyException later")
//  How to test async NSInternalInconsistencyException throw?
    }
    
    func testEuqal() {
        let msg = try? RFMessage { m in
            m.identifier = "zz"
        }
        let msg2 = try? RFMessage { m in
            m.identifier = (msg?.identifier)!
        }
        XCTAssertEqual(msg, msg2)
        XCTAssert(msg == msg2)
        XCTAssert(msg?.hash == msg2?.hash)
    }
}
