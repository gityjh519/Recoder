//
//  AlterTimeController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class AlterTimeController: BaseController {
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var model: DetialItemJson!
    
    var finishedBlock: ((_ model: DetialItemJson) -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "修改日期和价格"
        datePicker.locale = Locale(identifier: "zh_GB")
        datePicker.calendar = .init(identifier: .gregorian)

        
        dateButton.setTitle(model.date, for: .normal);

        let rightItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonItemAction(_:)));
        navigationItem.rightBarButtonItem = rightItem
        
        configBtn(btn: dateButton)
        
        priceTextField.text = model.price

        

        // Do any additional setup after loading the view.
    }
    
    func configBtn(btn: UIButton) {
        btn.setImage(UIImage(), for: .normal)
        btn.setImage(UIImage(), for: .selected)
        btn.setBackgroundImage(UIImage(), for: .normal)
        btn.setBackgroundImage(UIImage(), for: .selected)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
    }
    
    @objc func buttonItemAction(_ btn: UIBarButtonItem) {
        
        model.date = dateButton.title(for: .normal) ?? DetialItemJson.forrmaterDate(date: Date())
        if let text = priceTextField.text?.realText {
            model.price = text
        }
        finishedBlock?(model)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
       
        let date = sender.date;
        let dateString = DetialItemJson.forrmaterDate(date: date);
        dateButton?.setTitle(dateString, for: .normal)
        
    }
    
    
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        datePicker.datePickerMode = .date;
        
       
    }

}
