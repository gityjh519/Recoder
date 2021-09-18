//
//  TimeViewCell.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class TimeViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var beginTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!{
        didSet{
            endTime.addCornerToLayer()
        }
    }
    
    weak var ctroller: TimeListController?
    
    var isChangeState = false
    
    override func awakeFromNib() {
        dateLabel.textColor = UIColor.label
        beginTime.textColor = UIColor.secondaryLabel
        endTime.textColor = UIColor.secondaryLabel 
        
    }

    func configCell(model: DetialItemJson) {
        endTime.text = model.priceState;
        dateLabel.text = model.date
        if !model.isMySelf {
            dateLabel.textColor = UIColor.red
            endTime.textColor = .white
            beginTime.textColor = .red
            endTime.backgroundColor = UIColor.red
        }else {
            endTime.textColor = .white
            dateLabel.textColor = UIColor.label
            beginTime.textColor = .secondaryLabel
            endTime.backgroundColor = UIColor(red: 26.0/255.0, green: 161.0/255.0, blue: 96.0/255.0, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else{
            return
        }
        if point.x > endTime.frame.minX - 20 {
            isChangeState = true
        }else {
            super.touchesBegan(touches, with: event)
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isChangeState {
            let table = superview as? UITableView;
            let index = table?.indexPath(for: self);
            if let idx = index {
                ctroller?.changeCurrentState(indexPath: idx)
            }
            isChangeState = false
        }else {
            super.touchesEnded(touches, with: event)
        }
    }
}
