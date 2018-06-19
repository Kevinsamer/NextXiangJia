//
//  MyInfoViewController.swift
//  NextXiangJia
//  个人资料
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
class MyInfoViewController: FormViewController {
    private var qq:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //设置ui
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK: - 设置ui
extension MyInfoViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
//        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "个人资料", navItem:self.navigationItem)
        navigationItem.title = "个人资料"
        //2.设置bodyContent
        setupBodyContent()
    }

    private func setupBodyContent(){
//        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - 50, y: finalScreenH / 2 - 20, width: 100, height: 40))
//        label.textAlignment = .center
//        label.text = "MyInfoPage"
//        self.view.addSubview(label)
//        self.view.backgroundColor = UIColor.random.lighten(by: 0.6)
        
        form +++ Section()
        <<< ImageRow("icon") { row in
            row.title = "头像"
            row.sourceTypes = [.PhotoLibrary, .Camera]
            row.clearAction = .yes(style: UIAlertActionStyle.destructive)
            }.cellUpdate { cell, row in
                cell.accessoryView?.layer.cornerRadius = 20
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            }
        <<< TextRow("username"){ row in
            row.title = "姓名"
            //row.tag = "username"
            row.placeholder = "请输入姓名"
            row.add(rule: RuleRequired())
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                    row.placeholder = "用户名不能为空"
                }
            })
        <<< PickerInputRow<String>("sex"){
            $0.title = "性别"
            $0.options = ["男","女"]
            $0.value = $0.options.first
            //$0.add(rule: RuleRequired())
            //$0.tag = "sex"
        }
        <<< DateRow("birthday"){
            $0.title = "生日"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
            //$0.tag = "date"
        }
        <<< PhoneRow("phone"){
            $0.title = "手机"
            $0.placeholder = "请输入手机号"
            $0.add(rule: RuleRequired())
            
            //$0.tag = "phone"
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                    row.placeholder = "手机号不能为空"
                }
            })
        <<< PhoneRow("tel"){
            $0.title = "电话"
            $0.placeholder = "请输入电话号码"
            //$0.tag = "tel"
        }
        <<< IntRow("zipCode"){
            $0.title = "邮编"
            $0.placeholder = "请输入邮编"
            //$0.tag = "zipCode"
        }
        <<< IntRow("qq"){
            $0.title = "QQ"
            $0.placeholder = "请输入QQ"
            //$0.tag = "qq"
        }
        <<< EmailRow("email"){
            $0.title = "邮箱"
            $0.placeholder = "请输入邮箱"
            //$0.tag = "email"
        }
        <<< ButtonRow("confirm"){
            $0.title = "确认"
            }.onCellSelection({ (cell, row) in
                var nameRow:TextRow = self.form.rowBy(tag: "username")!
//                var sexRow:PickerInputRow<String> = self.form.rowBy(tag: "sex")!
//                var dateRow:DateRow = self.form.rowBy(tag: "birthday")!
//                var phoneRow:PhoneRow = self.form.rowBy(tag: "phone")!
//                var telRow:PhoneRow = self.form.rowBy(tag: "tel")!
//                var zipCodeRow:IntRow = self.form.rowBy(tag: "zipCode")!
//                var qqRow:IntRow = self.form.rowBy(tag: "qq")!
//                var emailRow:EmailRow = self.form.rowBy(tag: "email")!
                var icon : ImageRow = self.form.rowBy(tag: "icon")!
                let values = self.form.values()
                print("\(values)--\(icon.value)")
                
        }).cellSetup({ (cell, row) in
            cell.backgroundColor = UIColor(named: "save_blue")
            cell.tintColor = .white
            
        })
        <<< ButtonRow("loginOut"){
            $0.title = "退出登录"
        }.cellSetup({ (cell, row) in
            cell.backgroundColor = UIColor(named: "line_gray")
            cell.tintColor = UIColor(named: "dark_gray")
        }).onCellSelection({ (cell, row) in
            print("退出登录")
        })
        
        // 开启导航辅助，并且遇到被禁用的行就隐藏导航
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // 开启流畅地滚动到之前没有显示出来的行
        animateScroll = true
        // 设置键盘顶部和正在编辑行底部的间距为20
        rowKeyboardSpacing = 20
    }
}