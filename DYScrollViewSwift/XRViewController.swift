//
//  XRViewController.swift
//  DYScrollViewSwift
//
//  Created by teriyakibob on 2017/4/20.
//  Copyright © 2017年 hoodsound. All rights reserved.
//

import UIKit
import XRCarouselView

class XRViewController: UIViewController {
    var  imageArr = [UIImage(named:"ds1") , UIImage( named:"ds2"), UIImage (named:"ds3"), UIImage(named:"ds4"), UIImage(named:"ds5" )]
    var  desArr = ["Sunday Afternoon","The Best","Winter Luv","Jack Tha Party","Check Tha Number"]
    
    @IBOutlet weak var xrView: XRCarouselView!

    @IBAction func start(_ sender: UIButton) {
        xrView.startTimer()
    }
    @IBAction func stop(_ sender: UIButton) {
        xrView.stopTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xrView.placeholderImage = UIImage(named: "background")
        //设置图片数组及图片描述文字
       xrView.imageArray = imageArr
       xrView.describeArray = desArr
      
        //改变图片切换模式
        xrView.changeMode = ChangeModeFade
        //设置每张图片的停留时间，默认值为5s，最少为2s
        xrView.time = 2
          //设置分页控件的图片,不设置则为系统默认
        xrView.setPageImage(UIImage(named:"current"), andCurrentPageImage: UIImage(named:"other"))
        //设置分页控件的位置，默认为PositionBottomCenter
        xrView.pagePosition = PositionBottomCenter
        
        /**
         *  修改图片描述控件的外观，不需要修改的传nil
         *
         *  参数一 字体颜色，默认为白色
         *  参数二 字体，默认为13号字体
         *  参数三 背景颜色，默认为黑色半透明
         */
     let  bgColor = UIColor.cyan
      let font = UIFont.systemFont(ofSize: 15)
        let textColor = UIColor.red
       xrView.setDescribeTextColor(textColor, font: font, bgColor: bgColor)
     
 

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
