//
//  TimeListController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class TimeListController: BaseController,UITableViewDataSource,UITableViewDelegate {
    
    var mainTable: UITableView!
    
    var listDate: [DetialItemJson]?
    
    var textName = ""
    
    
    var finishedBlock: ((_ list: [DetialItemJson]?)-> Void)?
    
    var price: String?
    
    var tableHeader: PadContentView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let t = title {
            textName = t;
        }
        
        mainTable = UITableView(frame: view.bounds);
        view.addSubview(mainTable);
        mainTable.estimatedRowHeight = 110
        mainTable.rowHeight = 84
        mainTable.showsVerticalScrollIndicator = false
        mainTable.register(UINib(nibName: "TimeViewCell", bundle: nil), forCellReuseIdentifier: "TimeViewCell")
        mainTable.allowsMultipleSelectionDuringEditing = true 
        mainTable.delegate = self
        mainTable.dataSource = self
        
        tableHeader = UINib(nibName: "PadContentView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PadContentView;
        tableHeader.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 130)
        mainTable.tableHeaderView = tableHeader
        
        
        let rightAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonItemAction(_:)))
        navigationItem.rightBarButtonItem = rightAdd
        
        
        setNaviTitle()
        
    }
    func setNaviTitle() {
       
        var myCountText = 0;
        var unCountText = 0;
        var myDays = 0;
        var unDays = 0;
        
        guard let list = listDate else {
            return
        }
        for item in list {
            
            let pInt = Int(item.price ?? price ?? "0") ?? 0
             
            if item.isMySelf {
                myDays += 1;
                myCountText += pInt
            }else {
                unDays += 1;
                unCountText += pInt
            }
        }

        tableHeader.configAllCountLabel(text: "\(unCountText + myCountText)元-\(list.count)天") 
        tableHeader.configUnCountLabel(text: "\(unCountText)元-\(unDays)天")
        tableHeader.configMyCountLabelText(text: "\(myCountText)元-\(myDays)天")
    }
    
    @objc func buttonItemAction(_ item: UIBarButtonItem) {
        
        
        let firstItem = listDate?.first;
        if listDate == nil {
            listDate = [DetialItemJson]()
        }
        listDate?.insert(.init(price: firstItem?.price), at: 0);
        mainTable.insertRows(at: [.init(row: 0, section: 0)], with: .automatic)
        setNaviTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            finishedBlock?(listDate)
        }
    }
    
    
    
    // MARK: - table view delegate implement
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listDate?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let model = listDate![indexPath.row]
        
        return UISwipeActionsConfiguration(actions: [.init(style: .normal, title: model.priceState, handler: { (action, subView, finished) in
            let text = model.isMySelf ? "未结账" : "已结账"
            self.configAlertMessage(message: "修改为" + text) {
                self.changeCurrentModelState(indexPath: indexPath)
                finished(true)
            }
        })])
    }
    
    @objc func changeCurrentState(indexPath: IndexPath) {
        let model = listDate![indexPath.row]
        let text = model.isMySelf ? "未结账" : "已结账"
        self.changeCurrentModelState(indexPath: indexPath)
//        self.configAlertMessage(message: "修改为" + text) {
//            
//        }
    }
    
    func changeCurrentModelState(indexPath: IndexPath) {
        
        guard let list = listDate else {
            return 
        }
        var model = list[indexPath.row];
        model.stateInt = model.reaseSateInt
        listDate?[indexPath.row] = model
        mainTable.reloadRows(at: [indexPath], with: .automatic)
        setNaviTitle()

    }
    @available(iOS 11.0, *)
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        UISwipeActionsConfiguration(actions: [.init(style: .normal, title: "删除", handler: { (action, subView, finished) in
            
            self.configAlertMessage(message: "是否删除当前的记录") {
                self.deleteIndexModel(indexPath: indexPath)
                finished(true)
                
            }
            
        })])
    }
    
    func deleteIndexModel(indexPath: IndexPath) {
        listDate?.remove(at: indexPath.row)
        mainTable.deleteRows(at: [indexPath], with: .automatic)
        setNaviTitle()
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeViewCell", for: indexPath) as! TimeViewCell
        cell.ctroller = self
        if let list = listDate {
            let json = list[indexPath.row]
            cell.configCell(model: json)
            if let text = json.price ?? price {
                cell.beginTime.text = text + "元"
            }
        }
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        let tempModel = listDate?[indexPath.row];
        let ctrl = AlterTimeController(nibName: "AlterTimeController", bundle: nil)
        ctrl.model = tempModel
        ctrl.finishedBlock = {
            (model: DetialItemJson) in
            self.listDate?[indexPath.row] = model;
            tableView.reloadData()
        }
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
    
}
