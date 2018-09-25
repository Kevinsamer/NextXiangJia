//
//  CoreDataHelper.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/13.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import CoreData
import UIKit
let firstOpenName:String = "aifbeifbiewaawhkahkshfiuewvbi27(&0"
let firstOpenPassword:String = "ijbhfaibfeliafaioehfaebfassd=++d2"

class AppUserCoreDataHelper{
    static let AppUserHelper = AppUserCoreDataHelper()//创建单例
    
    private func saveData(){
        do {
            try context.save()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
//    func insertData<T>(TName:String, model:T, addTData:@escaping (Any)->()){
//        let TModel = NSEntityDescription.insertNewObject(forEntityName: TName, into: context) as! T
//        addTData(TModel)
//        saveData()
//    }
    //新建用户
    func insertAppUser(isFirstOpen isFirst:Bool = true, username name:String = firstOpenName, password pass:String = firstOpenPassword, appUserID id:Int = -1){
        let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as! AppUser
        appUser.id = Int32(id)
        appUser.isFirstOpen = isFirst
        appUser.username = name
        appUser.password = pass
        saveData()
    }
    
//    func getData(fetRequest request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]{
//        do {
//            return try context.fetch(request) as! [NSManagedObject]
//        } catch {
//            fatalError("\(error.localizedDescription)")
//        }
//    }
    //查询
    func getAppUser() -> AppUser?{
        let fetchRequest:NSFetchRequest = AppUser.fetchRequest()
//        fetchRequest.fetchLimit = 10 //限定查询结果的数量
//        fetchRequest.fetchOffset = 0 //查询的偏移量
//        //设置查询条件
//        let predicate = NSPredicate(format: "id= '1' ", "")
//        fetchRequest.predicate = predicate
        do {
            let appUsers = try context.fetch(fetchRequest)
            if appUsers.count > 0 {
                return appUsers[0]
            }else {
                return nil
            }
        } catch  {
            fatalError("\(error)")
        }
        
    }
    //修改信息
    func modifyAppUser(appUser user:AppUser){
        saveData()
    }
    //注销当前用户
    func delAppUser(compile: @escaping ()->()){
        context.delete(AppDelegate.appUser!)
        saveData()
        //注销后添加一个初始用户
        insertAppUser(isFirstOpen: true, username: firstOpenName, password: firstOpenPassword, appUserID: -1)
        AppDelegate.appUser = AppUserCoreDataHelper.AppUserHelper.getAppUser()
        compile()
    }
}
