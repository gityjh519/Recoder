//
//  ContactsModel.swift
//  DestinationProject
//
//  Created by yaojinhai on 2020/10/27.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

struct ContactsModel: Codable {
    let id: String
    let name: String
    var dateString: String
    var imageURL: String
    var members: [ContactsModel]?
    
    init(name: String) {
        ContactsModel.dateFormater.dateFormat = "yyyyMMddHHmmss"
        id = ContactsModel.dateFormater.string(from: Date())
        ContactsModel.dateFormater.dateFormat = "yyyy年MM月dd日\nEEEE HH:mm"
        dateString = ContactsModel.dateFormater.string(from: Date())
        self.name = name;
        self.imageURL = ""
        members = nil
        
    }
    
    private static var dateFormater: DateFormatter {
        let formter = DateFormatter()
        formter.calendar = .init(identifier: .gregorian)
        return formter
    }
    var currentDate: String {
        ContactsModel.dateFormater.dateFormat = "yyyy年MM月dd日\nEEEE HH:mm"
        return ContactsModel.dateFormater.string(from: Date())
    }
    
}

extension ContactsModel {
    
    static func ceateList() -> [ContactsModel] {

         let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/userData/";
         let keyPath = path + "key";
         let json = JSONDecoder();
         guard let data = try? Data(contentsOf: URL(fileURLWithPath: keyPath)) else{
             return [ContactsModel]()
         }
         
         guard let keys = try? json.decode([String].self, from: data) else{
             return [ContactsModel]()
         }
         DataBaseManger.saveDataForKey(keys: keys);
         var allListModel = [ContactsModel]()
         for key in keys {
             let rootPath = path + key;
             if let modelData = try? Data(contentsOf: URL(fileURLWithPath: rootPath)) {
                 if let model = try? json.decode(ContactsModel.self, from: modelData) {
                     allListModel.append(model)
                     DataBaseManger.saveDataModel(item: model);
                 }
             }
             
         }
         return allListModel
     }
     
    
     
     func saveCurrentRemark(remark: String) {
         let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/userData/remark/";
         let file = FileManager.default;
         if !file.fileExists(atPath: path) {
             try? file.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
         }
         try? remark.write(to: URL(fileURLWithPath: path + id), atomically: true, encoding: .utf8)
     }
     func readRemark() -> String {
         let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/userData/remark/";
         let value = try? String(contentsOf: URL(fileURLWithPath: path + id))
         return value ?? ""
     }
}


class DataBaseManger: NSObject {
    
    fileprivate static var dataDict = [String: ContactsModel]();
    fileprivate static var dataForKey = [String]()
    
    fileprivate static var changeKeyId = [String]()
    
    
    private override init() {
        super.init()
    }
    
    class func saveDataModel(item: ContactsModel) {
        dataDict[item.id] = item;
        changeKeyId.append(item.id)
    }
    class func saveDataForKey(keys: [String]) -> Void {
        dataForKey = keys
    }
    
    class func removeDataItem(id: String) {
        dataDict.removeValue(forKey: id)
        changeKeyId.append(id)

    }
    
    class func saveToFileData() {
        
        
        if changeKeyId.isEmpty  {
            return;
        }
     
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/userData/";
        let file = FileManager.default;
        if !file.fileExists(atPath: path) {
            try? file.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        

        let rootPath = path + "key";
        let json = JSONEncoder();
        let keyData = try? json.encode(dataForKey);
        try? keyData?.write(to: URL(fileURLWithPath: rootPath))
        
        for item in dataDict {
            if changeKeyId.contains(item.key) {
                let dataPath = path + item.key;
                let data = try? json.encode(item.value)
                try? data?.write(to: URL(fileURLWithPath: dataPath))
            }else {
//                print("不需要修改的文件》\(item.key)" + item.value.dateString + item.value);
            }
        }
        changeKeyId.removeAll()

    }
}
