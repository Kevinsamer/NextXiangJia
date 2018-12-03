//
//  AddNewAddressViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/9.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Eureka

class AddNewAddressViewController: FormViewController {
    var name:String?
    var phoneNum:String?
    var address:(Area,Area,Area)?
    var detailedAddress:String?
    var telNum:String?
    var zipCode:Int?
    var myCenterViewModel:MycenterViewModel = MycenterViewModel()
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
            let nameRule = RuleClosure<String>{rowValue in
                return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "请输入收货人姓名") : nil
            }
            $0.add(rule: nameRule)
            $0.validationOptions = .validatesOnBlur
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                }
            })
        <<< PhoneRow("phoneNum"){
            $0.title = "手机:"
            $0.placeholder = "请输入手机号码"
            let phoneRule = RuleClosure<String>{rowValue in
                return YTools.isPhoneNumber(phoneNum: (rowValue)) ? nil : ValidationError.init(msg: "手机号码输入不正确")
            }
            $0.add(rule: phoneRule)
            $0.validationOptions = .validatesOnBlur
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                }
            })
        <<< PhoneRow("telNum"){
            $0.title = "固话:"
            $0.placeholder = "请输入固话号码(可略过)"
        }
        <<< PhoneRow("zipCode"){
            $0.title = "邮编:"
            $0.placeholder = "请输入邮编"
            let zipRule = RuleClosure<String>{rowValue in
                return YTools.isZipCodeNumber(zipCodeNum: (rowValue)) ? nil : ValidationError.init(msg: "邮编输入不正确")
            }
            $0.add(rule: zipRule)
            $0.validationOptions = .validatesOnBlur
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                }
            })
        <<< LabelRow("address"){
            $0.title = "所在地区:"
            $0.value = "点击选择所在地区 ＞"
            let addressRule = RuleClosure<String>{rowValue in
                return rowValue == "点击选择所在地区 ＞" ? ValidationError.init(msg: "请选择所在地区") : nil
            }
            $0.add(rule: addressRule)
            $0.validationOptions = .validatesOnChange
            }.cellSetup({ (cell, row) in
                //cell.backgroundColor = .black
//                cell.tintColor = .black
//                cell.bounds = CGRect(x: 0, y: 0, width: 600, height: 50)
                let right = UIImageView(image: UIImage(named: "arrow_right"))
                right.frame = CGRect(x: cell.frame.width, y: 0, width: cell.frame.height, height: cell.frame.height)
                right.contentMode = UIViewContentMode.center
                //cell.addSubview(right)
                
            }).onCellSelection({ (cell, row) in
//                AreaPickView.showChooseCityView(selectCityHandle: { (province, city, town) in
//                    self.address = (province,city,town)
//                    row.value = "\(province) \(city) \(town) ＞"
////                    row.title = "所在地区： \(province) \(city) \(town)"
//                    row.updateCell()
//                    print(self.address ?? ("province","city","town"))
//                })
                MyAreaPickerView.showAreaPickerView(selectCityHandle: { (province, city, town) in
                    self.address = (province, city, town)
                    row.value = "\(province.area_name) \(city.area_name) \(town.area_name)"
                    row.updateCell()
                    YTools.myPrint(content: "\(province.area_name) \(city.area_name) \(town.area_name)", mode: true)
                })
            }).cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.textLabel?.textColor = .red
                }
            })
        <<< LabelRow("addressLabel"){
            $0.title = "详细地址"
            
        }
        <<< TextAreaRow("detailedAddress"){
            $0.placeholder = "请输入详细地址"
            let addressRule = RuleClosure<String>{rowValue in
                return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "请输入详细地址") : nil
            }
            $0.add(rule: addressRule)
            $0.validationOptions = .validatesOnBlur
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    (self.form.rowBy(tag: "addressLabel") as! LabelRow).cell.textLabel?.textColor = .red
                }else{
                    (self.form.rowBy(tag: "addressLabel") as! LabelRow).cell.textLabel?.textColor = .black
                }
            })
        <<< ButtonRow("saveButton"){
            $0.title = "保存"
            }.cellSetup({ (cell, row) in
                cell.tintColor = .white
                cell.backgroundColor = .red
            }).onCellSelection({[unowned self] (cell, row) in
                //print(self.form.values())
                let accept_name = (self.form.rowBy(tag: "name") as? TextRow)?.value ?? ""
                //let id = Int((AppDelegate.appUser?.user_id)!)
                let province = Int(self.address?.0.area_id ?? "100000")
                let city = Int(self.address?.1.area_id ?? "100000")
                let area = Int(self.address?.2.area_id ?? "100000")
                let address = (self.form.rowBy(tag: "detailedAddress") as? TextAreaRow)?.value ?? ""
                let zip = (self.form.rowBy(tag: "zipCode") as? PhoneRow)?.value ?? ""
                let telphone = (self.form.rowBy(tag: "telNum") as? PhoneRow)?.value ?? ""
                let mobile = (self.form.rowBy(tag: "phoneNum") as? PhoneRow)?.value ?? ""
                //print("id=\(id)  province=\(province) city=\(city) area=\(area) address=\(address) zip=\(zip) telphone=\(telphone) mobile=\(mobile) accept_name=\(accept_name)")
                var errors = self.form.validate()
                if errors.count != 0 {
                    YTools.showMyToast(rootView: self.view, message: errors[0].msg)
                }else{
                    self.myCenterViewModel.requestAddAddress(acceptName: accept_name, province: province!, city: city!, area: area!, address: address, zip: zip, telphone: telphone, mobile: mobile, finishCallback: { msg in
                        if msg == ""{
                            //添加成功
                            self.navigationController?.popViewController(animated: true)
                            //TODO:测试、增加地址页面无数据情况
                        }else{
                            //添加失败
                            YTools.showMyToast(rootView: self.view, message: msg)
                        }
                    })
                }
            })
        // 开启导航辅助，并且遇到被禁用的行就隐藏导航
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // 开启流畅地滚动到之前没有显示出来的行
        animateScroll = true
        // 设置键盘顶部和正在编辑行底部的间距为20
        rowKeyboardSpacing = 20
    }
}
