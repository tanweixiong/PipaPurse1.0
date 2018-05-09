//
//  NetWorkTool.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/21.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration
import SVProgressHUD

let timeoutIntervalForRequest: Int = 120

enum NetType: CustomStringConvertible {
    case WLWAN
    case WiFi
    
    var description : String {
        switch self {
        case .WLWAN: return "无线广域网"
        case .WiFi: return "WiFi"
        }
    }
}

enum NewStatus:CustomStringConvertible  {
    case OffLine
    case OnLine
    case Unknow
    
    var description: String {
        switch self {
        case .OffLine: return "离线"
        case .OnLine: return "在线"
        case .Unknow: return "未知"
        }
    }
}

enum UploadType: String {
    ///纯文本
    case textOnly = "text/plain"
    ///HTML文档
    case html = "text/html"
    ///XHTML文档
    case xhtml = "application/xhtml+xml"
    ///gif图片
    case gif = "image/gif"
    ///jpeg图片
    case jpeg = "image/jpeg"
    ///png图片
    case png = "image/png"
    ///mpeg动画
    case mpeg = "video/mpeg"
    ///任意的二进制数据
    case any = "application/octet-stream"
    ///PDF文档
    case pdf = "application/pdf"
    ///Word文件
    case word = "application/msword"
    ///RFC 822形式
    case rfc822 = "message/rfc822"
    ///HTML邮件的HTML形式和纯文本形式，相同内容使用不同形式表示
    case alternative = "multipart/alternative"
    ///使用HTTP的POST方法提交的表单
    case urlencoded = "application/x-www-form-urlencoded"
    ///使用HTTP的POST方法提交的表单,但主要用于表单提交时伴随文件上传的场合
    case formdata = "multipart/form-data"
    
}

class ZYNetWorkTool: NSObject {
    
    class func requestData(_ requestType: HTTPMethod, URLString: String, language: Bool, parameters: [String : Any]?, showIndicator: Bool, success: @escaping (_ response : Any) -> () , failture: @escaping(_ error: Error) -> ()) {
        var requestParameters = parameters
        let mutableParams = NSMutableDictionary.init(dictionary: parameters!)
        if parameters != nil {
            if language {
                let languageStr = UserDefaults.standard.value(forKey: UserLanguage) as! String
                if languageStr == "zh-Hans" {
                    mutableParams["language"] = "0"
                } else if languageStr == "en" {
                    mutableParams["language"] = "1"
                }
            }
            let jsonParameters =  Tools.getJSONStringFromDictionary(dictionary:mutableParams as NSDictionary)
            requestParameters = ["data":jsonParameters]
        }
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.configuration.timeoutIntervalForRequest = TimeInterval(timeoutIntervalForRequest)
        Tools.DLog(message:"url \(URLString), type \(requestType)")
        Tools.DLog(message:"params \(String(describing: parameters))")
        if parameters != nil {
            sessionManager.request(URLString, method: requestType, parameters: requestParameters).validate().responseJSON { (response) in
                Tools.DLog(message:"all response info \(response)")
                switch response.result {
                case .success(let value):
                    success(value)
                    let jsonString = NSString(data:response.data!,encoding: String.Encoding.utf8.rawValue)
                    let respondDict = Tools.getDictionaryFromJSONString(jsonString: jsonString! as String)
                    if respondDict["code"] != nil {
                        let code = respondDict["code"] as! Int
                        if code < 0 {
                            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_tokenout"))
                            Tools.removeCacheLoginData()
                            Tools.switchToLoginViewController()
                        }
                    }
                case .failure(let error):
                    Tools.DLog(message:"error \(error.localizedDescription)")
                    failture(error)
                    if showIndicator {
                        SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
                    }
                }
            }
        } else {
            sessionManager.request(URLString, method: requestType).validate().responseJSON { (response) in
                
                Tools.DLog(message:"all response info \(response)")
                
                switch response.result {
                case .success(let value):
                    success(value)
                    
                case .failure(let error):
                    
                    Tools.DLog(message:"error \(error.localizedDescription)")
                    failture(error)
                    if showIndicator {
                        SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
                    }
                }
            }
        }
    }
    
    class func uploadPictures(url: String, parameter :[String:Any]?, image: UIImage, imageKey: String,success : @escaping (_ response : [String : AnyObject])->(), fail : @escaping (_ error : Error)->()){
        let requestHead = ["content-type":"multipart/form-data"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if parameter != nil {
                    /*
                     for (key,value) in parameter!{
                     let valuedata = (value as! String).data(using: String.Encoding.utf8)
                     multipartFormData.append(valuedata!, withName:key)
                     Tools.DLog(message: multipartFormData)
                     }*/
                    
                    let token = SingleTon.shared.userInfo?.token!
                    let params = ["token" : token]
                    let jsonParameters =  Tools.getJSONStringFromDictionary(dictionary:params as NSDictionary)
                    let requestParameters = ["data":jsonParameters]
                    multipartFormData.append(jsonParameters.data(using: String.Encoding.utf8)!, withName: "data")
                    Tools.DLog(message: url)
                    Tools.DLog(message: multipartFormData)
                    
                }
                
                let imageName = Tools.getCurrentTime() + ".jpg"
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.1)!, withName: "photo", fileName: imageName, mimeType: "image/jpeg")
        },
            to: url,
            headers: requestHead,
            encodingCompletion: { result in
                switch result {
                    
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                        }
                    }
                    
                case .failure(let error):
                    fail(error)
                }
        }
        )
    }
    
    class func uploadMuchPictures(url: String, parameter :[String:Any]?, imageArray: NSArray, imageKey: String,success : @escaping (_ response : [String : AnyObject])->(), fail : @escaping (_ error : Error)->()){
        let requestHead = ["content-type":"multipart/form-data"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if parameter != nil {
                    for (key,value) in parameter!{
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName:key)
                    }
                }
                if imageArray.count != 0 {
                    let imageName = Tools.getCurrentTime() + ".jpg"
                    for index in 0...imageArray.count - 1 {
                        let image:UIImage = imageArray[index] as! UIImage
                        let scalingImage = OCTools.imageByScalingAndCropping(for: CGSize(width:500,height:500), withSourceImage: image)
                        multipartFormData.append(UIImageJPEGRepresentation(scalingImage!, 1.0)!, withName: imageKey, fileName: imageName, mimeType: "image/jpeg")
                    }
                }
        },
            to: url,
            headers: requestHead,
            encodingCompletion: { result in
                switch result {
                    
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                        }
                    }
                    
                case .failure(let error):
                    fail(error)
                }
        }
        )
    }

    
    //上传文件方式
    class func uploadFile(url: String, parameter :[String:Any]?, filePath: String, fileName: String,success : @escaping (_ response : [String : AnyObject])->(), fail : @escaping (_ error : Error)->()){
        let requestHead = ["content-type":"multipart/form-data"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if parameter != nil {
                    let jsonParameters =  Tools.getJSONStringFromDictionary(dictionary:parameter! as NSDictionary)
                    multipartFormData.append(jsonParameters.data(using: String.Encoding.utf8)!, withName: "data")
                }
                let fileManager = FileManager.default
                let data = fileManager.contents(atPath: filePath)
                if data == nil {
                    SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "perseon_Choose_Upload_File"))
                    return
                }
                //根据扩展名上传文件
                if filePath.contains(".docx") {
                    multipartFormData.append(data!, withName: "file", fileName: "docx", mimeType: UploadType.word.rawValue)
                }else if filePath.contains(".pdf"){
                    multipartFormData.append(data!, withName: "file", fileName: "pdf", mimeType: UploadType.pdf.rawValue)
                }else if filePath.contains(".text"){
                    multipartFormData.append(data!, withName: "file", fileName: "text", mimeType: UploadType.textOnly.rawValue)
                }else if filePath.contains(".json"){
                    multipartFormData.append(data!, withName: "file", fileName: "text", mimeType: UploadType.textOnly.rawValue)
                }else{
                    multipartFormData.append(data!, withName: fileName)
                }
        },
            to: url,
            headers: requestHead,
            encodingCompletion: { result in
                switch result {
                    
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                            let jsonString = NSString(data:response.data!,encoding: String.Encoding.utf8.rawValue)
                            let respondDict = Tools.getDictionaryFromJSONString(jsonString: jsonString! as String)
                            if respondDict["code"] != nil {
                            let code = respondDict["code"] as! Int
                                if code == 200 {
                                    SVProgressHUD.showSuccess(withStatus:LanguageHelper.getString(key: "perseon_Upload_Finish"))
                                }
                             if code < 0 {
                              SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_tokenout"))
                                Tools.removeCacheLoginData()
                                 Tools.switchToLoginViewController()
                            }
                        }
                        }
                    }
                    
                case .failure(let error):
                    fail(error)
                }
        }
        )
    }
}
