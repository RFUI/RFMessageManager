//
//  DMSVProgress.swift
//  Example-iOS
//
//  Created by BB9z on 28/03/2018.
//

import UIKit

class DMSVProgressViewController: UITableViewController {
    lazy var messager: RFSVProgressMessageManager = {
        return RFSVProgressMessageManager()
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messager.hideAll()
    }
    
    // MARK: -
    
    @IBOutlet var defaultNavigationItem: MBNavigationItem!
    @IBOutlet var queueNavigationItem: UINavigationItem!
    
    var queuedMessage: [ RFMessage ] = []
    var isQueueMode: Bool = false {
        didSet {
            if isQueueMode {
                defaultNavigationItem.apply(queueNavigationItem, animated: true)
            }
            else {
                defaultNavigationItem.restore(animated: true)
            }
        }
    }
    @IBAction func onQueueMode(_ sender: Any) {
        queuedMessage.removeAll()
        isQueueMode = true
    }
    @IBAction func onExitQueueMode(_ sender: Any) {
        queuedMessage.removeAll()
        isQueueMode = false
    }
    @IBAction func onExecuteQueue(_ sender: Any) {
        for m in queuedMessage {
            messager.show(m)
        }
        queuedMessage.removeAll()
        isQueueMode = false
    }
    
    // MARK: -
    
    @IBOutlet weak var rowLoading: UITableViewCell!
    @IBOutlet weak var rowLoadingModal: UITableViewCell!
    @IBOutlet weak var rowSuccess: UITableViewCell!
    @IBOutlet weak var rowFail: UITableViewCell!
    @IBOutlet weak var rowInfo: UITableViewCell!
    @IBOutlet weak var rowHide: UITableViewCell!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell! = tableView.cellForRow(at: indexPath)
        var msg: RFNetworkActivityMessage?
        switch cell {
        case rowLoading:
            if isQueueMode {
                msg = RFNetworkActivityMessage(identifier: "load1", message: "load1: dismiss after 2s", status: .loading)
                msg?.displayDuration = 2
            }
            else {
                msg = RFNetworkActivityMessage(identifier: "load1", message: "load1: this message won't auto dismiss", status: .loading)
            }
            
        case rowLoadingModal:
            msg = RFNetworkActivityMessage(identifier: "load2", message: "load2: dismiss after 3s", status: .loading)
            msg?.modal = true
            msg?.displayDuration = 3
            
        case rowSuccess:
            msg = RFNetworkActivityMessage(identifier: "success", message: "success", status: .success)
            
        case rowFail:
            msg = RFNetworkActivityMessage(identifier: "fail", message: "fail", status: .fail)
            
        case rowInfo:
            msg = RFNetworkActivityMessage(identifier: "info", message: "info", status: .info)
            
        case rowHide:
            if let dm = messager.displayingMessage {
                messager.hide(withIdentifier: dm.identifier)
            }
            
        default: break
        }
        
        if msg != nil {
            if isQueueMode {
                queuedMessage.append(msg!)
            }
            else {
                messager.show(msg!)
                print(messager)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func hideMessage(identifier: String) {
        messager.hide(withIdentifier: identifier)
    }
}

