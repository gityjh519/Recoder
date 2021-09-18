//
//  ContactMainController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/10/27.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class ContactMainController: UIViewController {

    private var mainTable: UITableView!
    private var tableHeader: SearchHeaderView!
    
    private var currentJson: ContactsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readData()

        mainTable = UITableView(frame: view.bounds);
        view.addSubview(mainTable);
        mainTable.estimatedRowHeight = 110
        mainTable.rowHeight = 90
        mainTable.showsVerticalScrollIndicator = false
        
        mainTable.register(UINib(nibName: "ContactItemCell", bundle: nil), forCellReuseIdentifier: "ContactItemCell")
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.keyboardDismissMode = .onDrag;
        
        tableHeader = UINib(nibName: "SearchHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? SearchHeaderView;
        tableHeader.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 60)
        mainTable.tableHeaderView = tableHeader
        tableHeader.clipItem = {
            (text: String) in
            
        }
        
        
        let rightAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonItemAction(_:)));
        navigationItem.rightBarButtonItem = rightAdd
    }
    
    func readData() {
        currentJson = ContactsModel(name: "我的");
        currentJson.members = ContactsModel.ceateList();
    }

    @objc func buttonItemAction(_ btn: UIBarButtonItem) {
        
    }
}

extension ContactMainController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - table view delegate implement
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentJson.members?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemCell", for: indexPath) as! ContactItemCell
        if let model = currentJson.members?[indexPath.row] {
//            cell.contentView
        }
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
