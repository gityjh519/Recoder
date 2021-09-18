//
//  BaseController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationItem.backBarButtonItem
        
        let backItem = UIBarButtonItem();
        backItem.title = "返回";
        navigationItem.backBarButtonItem = backItem;
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }

    
    func configAlertMessage(message: String,isAutoDismiss: Bool = false,doneBlock: (()->Void)?) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert);
        
        if !isAutoDismiss {
            alert.addAction(.init(title: "确定", style: .default, handler: { (finished) in
                doneBlock?()
            }))
        }
        
        if doneBlock != nil && !isAutoDismiss {
            alert.addAction(.init(title: "取消", style: .cancel, handler: { (finished) in
                
            }))
        }
        
        present(alert, animated: true) { 
            
        }
        if isAutoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { 
                alert.dismiss(animated: true) { 
                    
                }
            }
        }
    }
}
