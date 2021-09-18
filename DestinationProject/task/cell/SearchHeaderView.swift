//
//  SearchHeaderView.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/10/27.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView,UISearchBarDelegate {
    @IBOutlet weak var searchText: UISearchBar!
    var clipItem: ((_ text: String)->Void)?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clipItem?(searchBar.text ?? "")
    }
    
 
}
