//
//  AddMapItemController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class AddMapItemController: BaseController,UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var perField: UITextField!
    
    @IBOutlet weak var bankField: UITextField!
    
    @IBOutlet weak var feeField: UITextField!
    
    
    @IBOutlet weak var remarkView: UITextView!
    var sendModel: MapItemJson!
    
    var finishedBlock: ((_ model: MapItemJson)->Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
  
        if let name = sendModel?.name {
            title = name
        }else {
            title = "添加一条"

        }
        remarkView.layer.borderColor = UIColor.lightGray.cgColor
        remarkView.layer.borderWidth = 1
        
        nameField.text = sendModel?.name
        bankField.text = sendModel?.bankName
        if let address = sendModel?.address?.realText {
            remarkView.text = address
        }
        perField.text = sendModel?.perRMB.description
        feeField.text = sendModel?.sendTime
        
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonItemAction(_:)));
        navigationItem.rightBarButtonItem = rightItem
    }
    

    @objc func buttonItemAction(_ btn: UIBarButtonItem) {
        
  
        
        view.endEditing(true)
        
        guard let name = nameField.text?.realText else{
            configAlertMessage(message: "请填写名称", isAutoDismiss: true) { 
                
            }
            return;
        }
        let perInt = perField.text ?? "0"
        
        
        var model = MapItemJson(name: name,bankName: bankField.text!, perRMB: Int(perInt) ?? 0,sendTime: feeField.text, address: remarkView.text);
        model.listCount = sendModel?.listCount;
        finishedBlock?(model)
        
        
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            let ctrl = BankListController();
            navigationController?.pushViewController(ctrl, animated: true)
            ctrl.finishedBlock = {
                (value: String) in
                textField.text = value;
            }
        }
        return textField.tag != 2
    }

}

extension String {
    var realText: String? {
        count > 0 ? self : nil
    }
}
