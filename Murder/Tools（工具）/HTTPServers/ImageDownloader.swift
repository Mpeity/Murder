//
//  ImageDownloader.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/18.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import Alamofire


class ImageDownloader: NSObject {
    // 线程安全
    static let shareInstance: ImageDownloader = {
        let shareInstance = ImageDownloader()
        return shareInstance
    }()
}

extension ImageDownloader {
    func start(urlString: String, imageData: Data, parameters: [String : AnyObject]?, finished: @escaping(_ progress: AnyObject?, _ response: AnyObject? , _ error: Error?) -> ()) {
        
    }
    
//
//    func loadImagesProgress (script: Script ,scriptNodeMapModel: ScriptNodeMapModel, currentIndex: Int, finished: @escaping(_ progress: Double?, _ response: AnyObject? , _ error: Error?) -> ()) {
//        //指定下载路径（文件名不变）
//        let destination: DownloadRequest.DownloadFileDestination = { _, response in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
//            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//
//        //开始下载
//        Alamofire.download(scriptNodeMapModel.attachment, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination).downloadProgress { progress in
//
//            print("index=\(scriptNodeMapModel.attachment):\(Thread.current)")
////            print("当前进度: \(progress.fractionCompleted)")
//            finished(progress.fractionCompleted, nil, nil)
//        }
//        .responseData { response in
//            if let imagePath = response.destinationURL?.path {
//
//                if (UserDefaults.standard.value(forKey: String(script.scriptId!)) != nil) {
//                    let data = ScriptLocalData.shareInstance.getNormalDefult(key: String(script.scriptId!))
//                    var dic = data as! Dictionary<String, AnyObject>
//                    let itemKey = String(scriptNodeMapModel.attachmentId)
//                    dic.updateValue(imagePath as AnyObject, forKey: itemKey)
//                    createScriptLocalData(key: String(script.scriptId!), value: dic as AnyObject)
//                } else {
//                    var dic = Dictionary<String, AnyObject>()
//                    let itemKey = String(scriptNodeMapModel.attachmentId)
//                    dic.updateValue(imagePath as AnyObject, forKey: itemKey)
//                    createScriptLocalData(key: String(script.scriptId!), value: dic as AnyObject)
//                }
//
//            }
//        }
//
//    }
    
    //MARK: 下载进度
    func loadImageProgress (currentIndex: Int,script: Script ,scriptNodeMapModel: ScriptNodeMapModel, finished: @escaping(_ progress: Double?, _ response: AnyObject? , _ error: Error?) -> ()) {

        
        //指定下载路径（文件名不变）
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            print("fileURL:\(fileURL)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
                 
        //开始下载
        Alamofire.download(scriptNodeMapModel.attachment, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination).downloadProgress { progress in
            
//            print("index=\(scriptNodeMapModel.attachment):\(Thread.current)")
//            print("当前进度: \(progress.fractionCompleted)")
            if progress.fractionCompleted == 1.0 {
                finished(progress.fractionCompleted, scriptNodeMapModel as AnyObject, nil)
            } else {
                finished(progress.fractionCompleted, nil, nil)
            }
        }
        .responseData { response in
            
            if response.error != nil {
                finished(nil, nil, response.error)
            }

            if let imagePath = response.destinationURL?.path,let image = UIImage(contentsOfFile: imagePath)  {

                if (UserDefaults.standard.value(forKey: String(script.scriptId!)) != nil) {
                    let data = ScriptLocalData.shareInstance.getNormalDefult(key: String(script.scriptId!))
                    var dic = data as! Dictionary<String, AnyObject>
                    let itemKey = String(scriptNodeMapModel.attachmentId)
                    dic.updateValue(imagePath as AnyObject, forKey: itemKey)
                    createScriptLocalData(key: String(script.scriptId!), value: dic as AnyObject)
                } else {
                    var dic = Dictionary<String, AnyObject>()
                    let itemKey = String(scriptNodeMapModel.attachmentId)
                    dic.updateValue(imagePath as AnyObject, forKey: itemKey)
                    createScriptLocalData(key: String(script.scriptId!), value: dic as AnyObject)
                }
                
            }
        }
     }

}


func createScriptLocalData(key:String, value: AnyObject) {
    ScriptLocalData.shareInstance.setNormalDefault(key: key, value: value as AnyObject)
}


