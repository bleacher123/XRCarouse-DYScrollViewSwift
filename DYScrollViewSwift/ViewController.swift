//
//  ViewController.swift
//  DYScrollViewSwift
//
//  Created by teriyakibob on 2017/4/15.
//  Copyright © 2017年 hoodsound. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
 
    
    @IBOutlet weak var pageControll: UIPageControl!
 //   @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    enum ScrollDirection {
        case Unknow
        case Left
        case Right
    }
    let screenWidth = UIScreen.main.bounds.size.width
    
    var scrollView:UIScrollView!
    /** 显示用的imageView */
    var currentImageView: UIImageView!
    /** 滚动的时候被“滚出来”的imageView */
    var otherImageView: UIImageView!
    /** 当前显示第几张图片 */
    var currentPage: Int = 0
    /** 所有图片数组 */
    
    var  imageArr = [UIImage(named:"ds1") , UIImage( named:"ds2"), UIImage (named:"ds3"), UIImage(named:"ds4"), UIImage(named:"ds5" )]
 
    /** 滚动方向 */
    var scrollDirection: ScrollDirection!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        pageControll.layer.zPosition = 5
    //    imageView.image = UIImage(named: "ds\(currentPage)")
    
     
        
        
        scrollDirection = ScrollDirection.Unknow
        
        // 初始化一下scrollView
       scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 50, width: screenWidth, height: 200))
        
         
        // 滚动范围3倍 X轴为 >= 3，才能实现左右都能滚动
        scrollView.contentSize = CGSize(width: screenWidth*3, height: 200)
    //     scrollView.contentSize = CGSize(width: scrollView.frame.size.width*3, height: 200)
  
        scrollView.isPagingEnabled = true
         scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        // 一开始，显示第0张图片
        currentPage = 0
        
        
        // 当前图片，一开始就需要显示的，并且显示在整个contentSize范围的中间。这样左右均可滚动
        currentImageView = UIImageView.init(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: 200))
     //   currentImageView = UIImageView.init(frame: CGRect(x: 40, y: 0, width: scrollView.frame.size.width*3, height: 200))
        
       
        currentImageView.image = imageArr[currentPage]
        
        scrollView.addSubview(currentImageView)
        
        // 初始化，位置别和_currentImageView重了即可
      //  otherImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        otherImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
      
        scrollView.addSubview(otherImageView)
        
        // 初始化就显示中间区域，永远都显示中间的区域，而_currentImageView永远在中间，也就意味着永远显示_currentImageView
        scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
     
    }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            /** 判断一下此时是向右滚动还是向左滚动，根据设想，停止时的scrollView显示的内容永远是中间，那么scrollView.contentOffset.x 应该永远是 scrollView.frame.size.width，这里就是SCREEN_WIDTH。那么在动的时候通过scrollView.contentOffset.x 就可以知道是向哪个方向滚动
             
             性能优化：1. 该方法在滚动过程中重复调用，向左向右滑动其实在改变时赋值即可，后续无需判断？  ——>利用self.scrollDirection进方向判断来优化判断逻辑
             2._otherImageView 反复调用 setFrame 和 setImage 方法，是否会有损性能？ ——>利用self.scrollDirection进方向判断来优化判断逻辑
             */
            
            if (scrollView.contentOffset.x > screenWidth) {
                
                if (self.scrollDirection == ScrollDirection.Unknow  || self.scrollDirection == ScrollDirection.Left) {
                    print("向右滚动")
                    
                    // 向右滚动则要把另一张图片放在右边
                    otherImageView.frame = CGRect(x: currentImageView.frame.origin.x + screenWidth, y: 0, width: screenWidth, height: 200)
          //    otherImageView.frame = CGRect(x: currentImageView.frame.origin.x + 200, y: 0, width: 200, height: 200)
                    
                    // 同时给这个imageView上图片,如果展示最后一张图，滚出的就成为第一张图
                    if (currentPage == imageArr.count - 1) {
                        otherImageView.image = imageArr[0];
                    } else  {
                        otherImageView.image = imageArr[currentPage + 1]
                    }
                    
                    self.scrollDirection = ScrollDirection.Right
                }
            } else if (scrollView.contentOffset.x < screenWidth) {
                
                if (self.scrollDirection == ScrollDirection.Unknow || self.scrollDirection == ScrollDirection.Right) {
                    print("向左滚动")
                    
                    // 同理向左
                   otherImageView.frame = CGRect(x: currentImageView.frame.origin.x - screenWidth, y: 0, width: screenWidth, height: 200)
                 //    otherImageView.frame = CGRect(x: currentImageView.frame.origin.x - 200, y: 0, width: 200, height: 200)
                    
                    if (currentPage == 0) {
                        otherImageView.image = imageArr[imageArr.count - 1]
                    } else  {
                        otherImageView.image = imageArr[currentPage - 1]
                    }
                    
                    self.scrollDirection = ScrollDirection.Left;
                }
            } else {
                self.scrollDirection = ScrollDirection.Unknow;
            }
            
            // 重置图像，就是把otherImageView拉到中间全部显示的时候，赶紧换currentImageView来显示，即把scrollView.contentOffset.x 又设置到原来的位置，那么_currentImageView又能够全部显示了，但是_currentImageView显示的上一张/下一张的图片，需要替换成当前图片。进入该判断次数不多
            if (scrollView.contentOffset.x >= screenWidth * 2) {
                print("向右越界")
                if (currentPage == 4) {
                    currentPage = 0
                } else {
                    currentPage += 1
                }
                currentImageView.image = imageArr[currentPage]
                scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
         
            } else if (scrollView.contentOffset.x <= 0) {
                print("向左越界");
                if (currentPage == 0) {
                    currentPage = 4;
                } else {
                    currentPage -= 1
                }
                currentImageView.image = imageArr[currentPage];
                scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
              
            }
         pageControll.currentPage = currentPage

    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIImage {
    /**
     *  重设图片大小
     */
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
//    func reSizeImage(reSize:CGSize) -> UIImage {
//        UIGraphicsBeginImageContext(reSize)
//        // 创建新的图片并制定大小
//        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
//        // 缩放画图
//        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height:  reSize.height))
//        
//        //获取图片
//        let reSizeImage  = UIGraphicsGetImageFromCurrentImageContext()
//        // 关闭图形上下文
//        
//        UIGraphicsEndImageContext()
//        return reSizeImage!
//    }
    
    /**
     *  等比率缩放
     */
//    func scaleImage(scaleSize:CGFloat)->UIImage {
//        let reSize = CGSize(width: self.size.width, height: self.size.height * scaleSize)
//        
//        return reSizeImage(reSize: reSize)
//    }
}

