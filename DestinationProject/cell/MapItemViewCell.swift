//
//  MapItemViewCell.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class MapItemViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UIButton!
    
    @IBOutlet weak var perLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(json: MapItemJson)  {
        nameLabel.setTitle(json.name, for: .normal)
        addressLabel.text = json.bankName + "(\(json.sendTime ?? "1"))"
        var haveAll = 0;
        let all = json.listCount?.reduce(0) { (result, subItem) -> Int in
            if subItem.isMySelf {
                haveAll += (Int(subItem.price ?? "a") ?? json.perRMB)
                return result
            }
            return result + (Int(subItem.price ?? "a") ?? json.perRMB)
        }
        
        let count = json.listCount?.count ?? 0

        perLabel.text = "已结账" + haveAll.description + "元-" + "共\(count)天" 
        countLabel.text = "未结账" + (all ?? 0).description + "元"
        
        

    }
    
    
}
