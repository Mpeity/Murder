//
//  BigImageViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/8/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import Alamofire

class BigImageViewController: UIViewController {
    
    var myScrollView: UIScrollView!

    var myImageView: UIImageView! = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        self.view.addSubview(myScrollView)


        myImageView.frame = CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT)
        self.myScrollView.addSubview(myImageView)
        
        //是否有,弹簧效果
        self.myScrollView.bounces = false
        //是否滚动
        self.myScrollView.isScrollEnabled = true
        //是否显示水平/垂直滚动条
        self.myScrollView.showsVerticalScrollIndicator = false
        self.myScrollView.showsHorizontalScrollIndicator = false
        self.myScrollView.isUserInteractionEnabled = true

        let url = "https://miaoxing.oss-cn-beijing.aliyuncs.com/202008/12/0e76072c0eddc8f66762f675e0fcbfe1.jpg"

        loadImageProgress(url: url) { (progress, response, error) in
            let imagePath = response
            if imagePath != nil {
                
                let image = UIImage(contentsOfFile: imagePath!)
                self.myImageView.size = image!.size
                self.myScrollView.contentSize = self.myImageView.bounds.size
                self.myImageView.image = image
                self.myImageView.sizeToFit()

            }
        }

    }


}

extension BigImageViewController {
    
    
    //MARK: 下载进度
    func loadImageProgress (url: String, finished: @escaping(_ progress: CGFloat?, _ response: String? , _ error: Error?) -> ()) {
       //指定下载路径（文件名不变）
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        //开始下载
        Alamofire.download(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination).downloadProgress { progress in

            Log("当前进度: \(progress.fractionCompleted)")
            Log("\(Float(progress.fractionCompleted))------\(Float(progress.totalUnitCount))")
            
            finished(Float(progress.fractionCompleted) as? CGFloat, nil, nil)

        }
        .responseData { response in

            if let imagePath = response.destinationURL?.path {

                finished(nil, imagePath as String , nil)

            }
        }
     }
}


