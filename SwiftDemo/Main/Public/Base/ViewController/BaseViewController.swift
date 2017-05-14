//
//  BaseViewController.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var reachability: Reachability?

    var doSomethingWhenNetworkNotReachable: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // 做一些你每一个VC都需要做的事

        configReachability()
    }

    private func configReachability() {
        reachability = Reachability(hostname: kURL_Reachability_Address)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            printLog("could not start reachability notifier")
        }
    }

    func reachabilityChanged(note: NSNotification) {

        let reachability = note.object as! Reachability

        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                printLog("WiFi上网")
            } else {
                printLog("4G上网")
            }
        } else {
            // 没网的时候需要做的事
            doSomethingWhenNetworkNotReachable?()
            printLog("当前没有网络")
        }
    }

    deinit {
        stopNotifier()
    }

    private func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }

}
