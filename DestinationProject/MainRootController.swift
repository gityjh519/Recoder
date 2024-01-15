//
//  MainRootController.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/9/14.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

protocol NumberChangeDelegate: NSObjectProtocol {
    var isAccuratePrice: Bool {set get}
}
class MainRootController: BaseController,UITableViewDelegate,UITableViewDataSource ,NumberChangeDelegate{
    
    var dataSource: [MapItemJson]!
    
    private var mainTable: UITableView!
    
    private var tableHeader: PadContentView!
    
    var isAccuratePrice = true{
        didSet{
            reloadCaculateCount()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的记录"
        
        mainTable = UITableView(frame: view.bounds);
        view.addSubview(mainTable);
        mainTable.estimatedRowHeight = 110
        mainTable.rowHeight = UITableView.automaticDimension
        mainTable.showsVerticalScrollIndicator = false
        mainTable.register(UINib(nibName: "MapItemViewCell", bundle: nil), forCellReuseIdentifier: "MapItemViewCell")
        mainTable.delegate = self
        mainTable.dataSource = self
        
        
        let rightAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonItemAction(_:)))
        navigationItem.rightBarButtonItem = rightAdd
        
        tableHeader = UINib(nibName: "PadContentView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PadContentView;
        tableHeader.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 130)
        tableHeader.controller = self
        mainTable.tableHeaderView = tableHeader
        
        
        readCacheData();

    }
    
    func saveCurrentData() {
        
        reloadCaculateCount()
        
        guard let list = dataSource else {
            return
        }
        let json = JSONEncoder();
        let data = try? json.encode(list)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/dataList/"
        let file = FileManager.default
        if !file.fileExists(atPath: path) {
            try? file.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = URL(fileURLWithPath: path + "list");
        try? data?.write(to: url)
        
    }
    
    func readCacheData() {
        
        defer {
            if dataSource == nil {
                dataSource = [MapItemJson]()
            }
            reloadCaculateCount()
        }
       
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/dataList/"
        print("path>>\(path)");
        let url = URL(fileURLWithPath: path + "list");
        guard let data = try? Data(contentsOf: url) else{
            return;
        }
        let json = JSONDecoder()
        dataSource = try? json.decode([MapItemJson].self, from: data);
 
        
    }
    
    @objc func buttonItemAction(_ item: UIBarButtonItem) {
        let ctrl = AddMapItemController(nibName: "AddMapItemController", bundle: nil)
        ctrl.finishedBlock = {
            (model: MapItemJson) in
            self.dataSource.insert(model, at: 0);
            self.mainTable.reloadData()
            self.saveCurrentData()
        }
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
    // MARK: - table view delegate implement
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0;
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            configAlertMessage(message: "是否删除当前的记录") { 
                self.dataSource?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.saveCurrentData()
            }            
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapItemViewCell", for: indexPath) as! MapItemViewCell
        let json = dataSource[indexPath.row];
        cell.configCell(json: json)
        cell.nameLabel.tag = indexPath.row;
        cell.nameLabel.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside);
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = dataSource[indexPath.row];
        let ctrl = TimeListController();
        ctrl.listDate = model.listCount;
        ctrl.price = model.perRMB.description
        ctrl.title = model.name
        ctrl.finishedBlock = {
            (list) in
            model.listCount = list
            self.dataSource[indexPath.row] = model;
            tableView.reloadData();
            self.saveCurrentData()

        }
        navigationController?.pushViewController(ctrl, animated: true)
    }

    func reloadCaculateCount() {
        
        var haveAll = 0
        let count = dataSource?.reduce(0) { (all, item) -> Int in
           all + (item.listCount?.reduce(0) { (result, subItem) -> Int in
            let count = (Int(subItem.price ?? "a") ?? item.perRMB)
            if subItem.isMySelf {
                haveAll += count
                return result
            }
              return result + count
           } ?? 0)
        } ?? 0
        
        let days = dataSource?.reduce(0, { (reuslt, item) -> Int in
            reuslt + (item.listCount?.count ?? 0)
        })
        
        if let spl = "\(haveAll + count)".converNumberSpellOut() , isAccuratePrice{
            tableHeader.configAllCountLabel(text: "\(spl)元-\(days ?? 0)天")

        }else {
            tableHeader.configAllCountLabel(text: "\(haveAll + count)元-\(days ?? 0)天")
        }
        

        tableHeader.configMyCountLabelText(text: "\(haveAll)元")
        tableHeader.configUnCountLabel(text: "\(count)元")
        
    }

    @objc func buttonAction(_ sender: UIButton) {
        
        let model = dataSource[sender.tag];
        
        let ctrl = AddMapItemController(nibName: "AddMapItemController", bundle: nil);
        ctrl.sendModel = model;
        
        ctrl.finishedBlock = {
            (model: MapItemJson) in
            self.dataSource[sender.tag] = model;
            self.mainTable.reloadRows(at: [.init(row: sender.tag, section: 0)], with: .automatic)
            self.saveCurrentData()

        }
        navigationController?.pushViewController(ctrl, animated: true)
    }
}


extension String {
    
    func converNumberSpellOut() -> String? {
        convertPerWan()
//        if let v = convertPerWan() {
//            return v
//        }
//        let numberF = NumberFormatter()
//        numberF.locale = Locale(identifier: "zh")
//        numberF.numberStyle = .spellOut
//        if let mony = Int(self),mony > 0 {
//            return numberF.string(from: NSNumber(value: mony))!
//        }
//        return nil
        
    }
    func convertPerWan() -> String? {
        let valueInt = Double(self) ?? 0
        if valueInt >= 10000 {
            let moneyStrl = String(format: "%0.2f万", (valueInt / 10000));
            return moneyStrl.replacingOccurrences(of: ".00", with: "")
        }
        return nil
    }
}


