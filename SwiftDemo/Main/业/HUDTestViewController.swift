//
//  HUDTestViewController.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit

class HUDTestViewController: BaseViewController, ProgressHUDAble {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        view.addSubview(button)
        button.backgroundColor = UIColor.Material.amber300
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(showHUD), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showHUD() {
        showWaitingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.hideAll()
        }
    }
}
