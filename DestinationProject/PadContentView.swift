//
//  PadContentView.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class PadContentView: UIView {
// 50

    @IBOutlet weak var allCountLabel: UILabel! {
        didSet{
            allCountLabel.addCornerToLayer()
        }
    }
    @IBOutlet weak var myCountLabel: UILabel!{
        didSet{
            myCountLabel.addCornerToLayer()
        }
    }
    
    @IBOutlet weak var unCountLabel: UILabel!{
        didSet{
            unCountLabel.addCornerToLayer()
        }
    }
    
    
    
    func configMyCountLabelText(text: String) {
        myCountLabel.text = "已结账\n" + text;
    }
    func configUnCountLabel(text: String) {
        unCountLabel.text = "未结账\n" + text;

    }
    func configAllCountLabel(text: String) {
        allCountLabel.text = "总计\n" + text
    }
    
}


extension UIView {
    func addCornerToLayer() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
    
}
