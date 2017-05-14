//
//  ProgressHUDAble.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit

/// 一个可以显示HUD的协议
protocol ProgressHUDAble {
    func showWaitingView(with message: String)
    func showError(message: String)
    func showToast(with message: String)

    func hideAll()
}

extension ProgressHUDAble where Self: BaseViewController {
    func showWaitingView(with message: String = "loading...") {
        KRProgressHUD.show(message: message)
    }

    func showError(message: String) {
        KRProgressHUD.showError(message: message)
    }

    func hideAll() {
        KRProgressHUD.dismiss()
    }

    func showToast(with message: String) {
        KRProgressHUD.showText(message: message)
    }
}

