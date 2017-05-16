//
//  HUDTestViewController.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit
import Alamofire

class HUDTestViewController: BaseViewController, ProgressHUDable {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        view.addSubview(button)
        button.backgroundColor = UIColor.Material.amber300
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(showHUD), for: .touchUpInside)


        NetworkManager.manager.fetchJSONArrayWithAPI(api: DouBanAPI.channels, responseKey: "group") { (result: Result<[Group]>) in
            if result.isFailure {
                printError(result.error?.localizedDescription)
            } else {
                printLog(result.value?[1].chls)
            }
            
        }
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
