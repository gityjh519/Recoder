//
//  ContactItemCell.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/10/27.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class ContactItemCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameButn: UIButton!
    @IBOutlet weak var leftImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func configCell(model: ) -> <#return type#> {
//        <#function body#>
//    }
    
}
