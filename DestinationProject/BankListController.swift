//
//  BankListController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class BankListController: BaseController ,UITableViewDelegate,UITableViewDataSource{

    var dataSource: [BankList]!
    
    var finishedBlock: ((_ name: String) -> Void)?
    
    private var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "银行列表"
        
        readJson()

        mainTable = UITableView(frame: view.bounds);
        view.addSubview(mainTable);
        mainTable.estimatedRowHeight = 110
        mainTable.rowHeight = UITableView.automaticDimension
        mainTable.showsVerticalScrollIndicator = false
        mainTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mainTable.delegate = self
        mainTable.dataSource = self
        
        
//        let rightAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonItemAction(_:)))
//        navigationItem.rightBarButtonItem = rightAdd
    }
    
    func readJson() {
        let path = Bundle.main.url(forResource: "BankPlist", withExtension: "plist")
        let array = NSArray(contentsOf: path!)
        let json = JSONDecoder()
        dataSource = array?.map({ (item) -> BankList in
            let data = try? JSONSerialization.data(withJSONObject: item, options: .fragmentsAllowed)
            return try! json.decode(BankList.self, from: data!)
        })
        self.mainTable?.reloadData()
    }
    
    // MARK: - table view delegate implement
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = dataSource[indexPath.row].name
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = dataSource[indexPath.row].name;
        finishedBlock?(name)
        navigationController?.popViewController(animated: true)
    }

}

struct BankList: Codable {
    let name: String
    let value: String
}
