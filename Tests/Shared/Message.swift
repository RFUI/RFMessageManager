//
//  Message.swift
//  RFMessageManager
//
//  Created by BB9z on 2019/4/29.
//  Copyright © 2019 RFUI. All rights reserved.
//

import Foundation

/// Message class for tests.
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

/// Manager class for tests.
class MessageManager: RFMessageManager {
    var lastDisplayingMessage: RFMessage?
    var lastNewMessage: RFMessage?

    override func replace(_ displayingMessage: RFMessage?, withNewMessage message: RFMessage?) {
        lastDisplayingMessage = displayingMessage
        lastNewMessage = message
    }

    var queueObjects: [TestMessage]? {
        return queuedMessages as? [TestMessage]
    }

    func reset() {
        hideAll()
        lastNewMessage = nil
        lastDisplayingMessage = nil
    }
}
