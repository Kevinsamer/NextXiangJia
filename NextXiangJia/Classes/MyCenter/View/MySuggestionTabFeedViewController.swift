//
//  MySuggestionTabFeedViewController.swift
//  NextXiangJia
//  我的建议
//  Created by DEV2018 on 2018/5/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MySuggestionTabFeedViewController: UIViewController, IndicatorInfoProvider{
    //MARK: - 懒加载
    lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: finalScreenH / 2 - 20, width: finalScreenW, height: 40))
        label.text = "暂无建议信息"
        label.textAlignment = .center
        return label
    }()
    
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var itemInfo: IndicatorInfo = "View"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.setui
        setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews {
            view.resignFirstResponder()
        }
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

//MARK: - setui
extension MySuggestionTabFeedViewController{
    private func setUI(){
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setNoDataLabel()
    }
    
    private func setNoDataLabel(){
        self.view.addSubview(noDataLabel)
    }
}
