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
        messager.hide(withIdentifier: nil)
    }
    
    @IBOutlet weak var rowLoading: UITableViewCell!
    @IBOutlet weak var rowLoadingModal: UITableViewCell!
    @IBOutlet weak var rowSuccess: UITableViewCell!
    @IBOutlet weak var rowFail: UITableViewCell!
    @IBOutlet weak var rowHide: UITableViewCell!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell! = tableView.cellForRow(at: indexPath)
        switch cell {
        case rowLoading:
            let msg = RFNetworkActivityIndicatorMessage(identifier: "load1", title: "load1", message: "this message won't auto dismiss", status: .loading)
            messager.show(msg)
            
        case rowLoadingModal:
            let msg = RFNetworkActivityIndicatorMessage(identifier: "load2", title: "load2", message: "this message won't auto dismiss", status: .loading)
            msg.modal = true
            messager.show(msg)
            
        case rowSuccess:
            let msg = RFNetworkActivityIndicatorMessage(identifier: "success", title: nil, message: "success", status: .success)
            messager.show(msg)
            
        case rowFail:
            let msg = RFNetworkActivityIndicatorMessage(identifier: "fail", title: nil, message: "fail", status: .fail)
            messager.show(msg)
            
        case rowHide:
            if let dm = messager.displayingMessage {
                messager.hide(withIdentifier: dm.identifier)
            }
            
        default: break
        }
        print(messager)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

