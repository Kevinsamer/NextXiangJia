//
//  MyEvaluationViewController.swift
//  NextXiangJia
//  商品评价
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class MyEvaluationViewController: UIViewController {
    //MARK: - 懒加载
    lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: finalScreenH / 2 - 20, width: finalScreenW, height: 40))
        label.textAlignment = .center
        label.text = "您当前没有评价信息"
        return label
    }()
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
extension MyEvaluationViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
        navigationItem.title = "商品评价"
        //2.设置bodyContent
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupNoDataView()
    }

    private func setupNoDataView(){
        
        self.view.addSubview(noDataLabel)
        
    }
}
