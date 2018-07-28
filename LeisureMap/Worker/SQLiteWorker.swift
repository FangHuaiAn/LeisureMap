//
//  SQLiteWorker.swift
//  LeisureMap
//
//  Created by 房懷安 on 2018/7/25.
//  Copyright © 2018年 房懷安. All rights reserved.
//

import Foundation
import UIKit
import SQLite


struct SQLiteWorker {
    
    private var db: Connection!
    
    private let categories = Table("servicecategory")
    private let id = Expression<Int>("id")
    private let name = Expression<String>("name")
    private let imagepath = Expression<String>("imagepath")
    
    init() {
        
        let sqlFilePath = NSHomeDirectory() + "/Documents/db.sqlite3"
        do {
            db = try Connection(sqlFilePath)
        } catch { print(error) }
        
        
        do {
            
            let count = try db.scalar(categories.count)
            print("init count:\(count)")
            
        } catch { print(error) }
    }
    
    func createDatabase()  {
        createdTable()
    }
    
    private func createdTable()  {
        
        do{
            let count = try db.scalar(categories.count)
            
            if count > 0 {
                try db.run(categories.drop())
            }
        }catch{
            print(error)
        }
        
        do {

            try db.run(categories.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(imagepath)
            })
        } catch { print(error) }
        
        do {
            
            let count = try db.scalar(categories.count)
            print("createdTable count:\(count)")
            
        } catch { print(error) }
        
        
    }
    
    //
    func insertData(_name: String, _imagepath: String){
        do {
            let insert = categories.insert(name <- _name, imagepath <- _imagepath)
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    //
    func readData() -> [ServiceCategory] {
        
        var responseArray : [ServiceCategory] = []
        
        for category in try! db.prepare(categories) {
            
            let serviceCategory = ServiceCategory()
            
            serviceCategory.Index = category[id]
            serviceCategory.Name = category[name]
            serviceCategory.ImagePath = category[imagepath]
            
            responseArray.append(serviceCategory)
        }
        
        responseArray.sort(by: { $0.Index < $1.Index })
        
        return responseArray
    }
    
    //
    func updateData(serviceId: Int, old_name: String, new_name: String) {
        let currcategories = categories.filter(id == serviceId)
        do {
            try db.run(currcategories.update(name <- name.replace(old_name, with: new_name)))
        } catch {
            print(error)
        }
        
    }
    
    //
    func delData(currcategoryIndex: Int) {
        let currcategories = categories.filter(id == currcategoryIndex)
        do {
            try db.run(currcategories.delete())
        } catch {
            print(error)
        }
    }
    
    //
    func clearAll()  {
        
        let categories = readData()
        
        var indexes : [Int] = []
        
        for category in categories{
            
            indexes.append(category.Index)
        }
        
        for index in indexes{
            delData(currcategoryIndex:index )
        }
        
    }
}

