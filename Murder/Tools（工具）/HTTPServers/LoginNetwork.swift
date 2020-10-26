//
//  LoginNetwork.swift
//  Murder
//
//  Created by m.a.c on 2020/8/7.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import AFNetworking


//MARK:- 注册
private let register_url = "/api/login/do_register"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * email 邮箱 String
 * captcha 验证码 Int
 * password 密码 String
 * repassword 确认密码 String
 */
func loadRegister(email: String, password:String, repassword: String, captcha: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = register_url
    let parameters = ["email" : email, "captcha": (captcha as NSString).intValue, "password" : password, "repassword": repassword] as [String : AnyObject]
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 验证码
private let captcha_url = "/api/login/get_emil_captcha"
/** 发送验证码
* @params [参数名] [类型] [是否必传]
* email [string]    是    邮箱
* scene [int]    是    场景值【1注册验证码2重置密码验证码】
*/
func loadCaptcha(email: String, scene: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = captcha_url
    
    let parameters = ["email" : email, "scene": (scene as NSString).intValue] as [String : AnyObject]
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 验证 验证码
private let check_captcha_url = "/api/login/check_captcha"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* email [string]    是    邮箱
* scene [int]    是    场景值【1注册验证码2重置密码验证码】
* captcha [int]    是    验证码
*/
func checkCaptcha(email: String, scene: String, captcha: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = check_captcha_url
    let parameters = ["email" : email, "scene": (scene as NSString).intValue, "captcha": (captcha as NSString).intValue] as [String : AnyObject]
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 登录
private let login_url = "/api/login/do_login"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* email [string]    是    邮件
* password [string]    是    密码
*/
func loadLogin(email: String, password: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = login_url
    let parameters = ["email" : email, "password" : password] as [String : AnyObject]
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 完善信息
private let edit_user_url = "/api/user/edit_user"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* nickname [string]    是    昵称
* head [int]    是    头像
* sex [int]    是    性别【1男2女】
*/
func editInformation(nickname: String, head: String, sex: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = edit_user_url
    let parameters = ["nickname": nickname, "head" : (head as NSString).intValue, "sex":(sex as NSString).intValue] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
//    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
//        finished(result as? [String : AnyObject], error)
//    }
}

//MARK:- 上传
private let upload_url = "/api/upload/index"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* file [file]    是    文件表单键名
*/
//func uploadImgae(file: AnyObject, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
//
//
//    let urlString = upload_url
//
//    let parameters = ["file" : file] as [String : AnyObject]
//
//
//
//    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
//        finished(result as? [String : AnyObject], error)
//    }
//}

func uploadImgae(imageData: Data, file: AnyObject, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    
    let urlString = upload_url

    let parameters = ["file" : file] as [String : AnyObject]
    
    NetworkTools.shareInstance.uploadImage(urlString: urlString, imageData: imageData, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 重置密码
private let find_password_url = "/api/login/find_password"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* email [string]    是    邮箱
* captcha [int]    是    重置密码验证码
* newpassword [string]    是    新密码
* repassword [string]    是    新密码确认密码
*/
func findPassword(email: String, password:String, repassword: String, captcha: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = find_password_url
    let parameters = ["email" : email, "captcha": (captcha as NSString).intValue, "newpassword" : password, "repassword": repassword] as [String : AnyObject]
    
//    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
//        finished(result as? [String : AnyObject], error)
//    }
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 版本控制
private let version_index_url = "/api/version/index"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* client [string]    是    平台【android|ios】
*/
func getVersionIndex(finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = version_index_url
    let parameters = ["client" : "ios"] as [String : AnyObject]

    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


