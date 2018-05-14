//
//  AddNewAddressViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/9.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Eureka
var name:String?
var phoneNum:String?
var address:(String,String,String)?
var detailedAddress:String?
var telNum:String?
var zipCode:Int?
class AddNewAddressViewController: FormViewController {

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
extension AddNewAddressViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "添加新地址", navItem:self.navigationItem)
        self.view.backgroundColor = .white
        //2.设置bodyContent
        setupBodyContent()
    }
    
    private func setupBodyContent(){
        form +++ Section()
        <<< TextRow("name"){
            $0.title = "收货人:"
            $0.placeholder = "请输入收货人姓名"
        }
        <<< TextRow("phonrNum"){
            $0.title = "手机:"
            $0.placeholder = "请输入手机号码"
        }
        <<< TextRow("telNum"){
            $0.title = "固话:"
            $0.placeholder = "请输入固话号码"
        }
        <<< TextRow("zipCode"){
            $0.title = "邮编:"
            $0.placeholder = "请输入邮编"
        }
        <<< LabelRow("address"){
            $0.title = "所在地区:"
            $0.value = "点击选择所在地区 ＞"
            }.cellSetup({ (cell, row) in
                //cell.backgroundColor = .black
//                cell.tintColor = .black
//                cell.bounds = CGRect(x: 0, y: 0, width: 600, height: 50)
                let right = UIImageView(image: UIImage(named: "arrow_right"))
                right.frame = CGRect(x: cell.frame.width, y: 0, width: cell.frame.height, height: cell.frame.height)
                right.contentMode = UIViewContentMode.center
                //cell.addSubview(right)
                
            }).onCellSelection({ (cell, row) in
                AreaPickView.showChooseCityView(selectCityHandle: { (province, city, town) in
                    address = (province,city,town)
                    row.value = "\(province) \(city) \(town) ＞"
//                    row.title = "所在地区： \(province) \(city) \(town)"
                    row.updateCell()
                    print(address)
                })
            })
        <<< LabelRow(){
            $0.title = "详细地址"
        }
        <<< TextAreaRow("detailedAddress"){
            $0.placeholder = "请输入详细地址"
        }
        <<< ButtonRow("saveButton"){
            $0.title = "保存"
            }.cellSetup({ (cell, row) in
                cell.tintColor = .white
                cell.backgroundColor = .red
            }).onCellSelection({ (cell, row) in
                print(self.form.values())
            })
        // 开启导航辅助，并且遇到被禁用的行就隐藏导航
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // 开启流畅地滚动到之前没有显示出来的行
        animateScroll = true
        // 设置键盘顶部和正在编辑行底部的间距为20
        rowKeyboardSpacing = 20
    }
}
