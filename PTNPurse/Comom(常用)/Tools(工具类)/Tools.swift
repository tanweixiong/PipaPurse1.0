//
//  Tools.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import Foundation

class Tools: NSObject {

    //判断是否为邮箱
    class func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._% -] @[A-Za-z0-9.-] \\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    //判断是否为电话号码
    class func validateMobile(mobile: String) -> Bool {
        //电话号码
        let MOBILE = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[067853])\\d{8}$"
        //中国电信
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        //中国联通
        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        if Tools.isValidateByRegex(regex: MOBILE, mobile: mobile) || Tools.isValidateByRegex(regex: CM, mobile: mobile) || Tools.isValidateByRegex(regex: CU, mobile: mobile) {
            return true
        }else{
            return false
        }
    }
    
    //获取服务器价格格式不包含符号
    class func getConversionPriceFormat(_ price:String)-> String {
        let newPrice = String(format: "%.2f", NSString(string:price).floatValue/100)
        return newPrice
    }
    
    //判断是否为密码
    class func validatePassword(password: String) -> Bool {
        let passwordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    //判断是否为6位数字
    class func validateAuthorCode(code: String) -> Bool {
        let passwordRegex = "^\\d{6}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: code)
    }
    
    
    class func validateNewPassword(pwd: String) -> Bool {
        if  5 < pwd.count  && pwd.count < 17 {
            return true
        }
        return false
    }
    
    //判断正则
    class func isValidateByRegex(regex: String,mobile:String)-> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: mobile)
    }
    
    //判断是否为验证码
    class func validateCode(code: String) -> Bool {
        if code.characters.count > 3 {
            return true
        }else{
            return false
        }
    }
    
    //判断是否登录
    class func validateLogin()->Bool{
        if !UserDefaults.standard.bool(forKey: R_Theme_isLogin) {
            return true
        }
        return false
    }
    
    //判断是否为空值
    class func judgmentNull(data:NSString)->String{
      
        if (((data as AnyObject).isEqual(NSNull.init())) == false) {
            return data as String
        }
        
        if (((data as AnyObject).isEqual(NSNull.init())) == false) {
            return data as String
        }
        
        if (((data as AnyObject).isEqual(NSNull())) == false)  {
            return data as String
        }
        return ""
    }
    
    //图片data转化字符串
    class func 获取图片转化字符串返回字符串(图片: UIImage)-> String {
        var 数据: NSData;
        if (UIImagePNGRepresentation(图片) == nil)
        {
            数据 = UIImageJPEGRepresentation(图片, 1.0)! as NSData;
        }
        else
        {
            数据 = UIImagePNGRepresentation(图片)! as NSData;
        }
        let 图片内容: String =  数据.base64EncodedString(options: .lineLength64Characters)
        return 图片内容;
    }
    
    class func getCorwdTimeStampToString(timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = timeStamp
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }
    
    //获取当前时间
    class func getCurrentTime()-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyyMMddHHmmss"
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
    //根据格式获取时间
    class func getCurrentTimeDateFormat(format:String)-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = format
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
    //根据根式获取当前时间
    class func getCurrentFormatTime(_ format:String)-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = format
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
      //转化特定的时间格式
    class func getTimeStampToString(timeStamp:String)->String {
        let now = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = timeStamp
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return String.init(timeStamp)
    }
    
    //获取价格的格式包含符号
    class func getConversionPriceFormatSymbol(_ price:String)-> String {
        let newPrice = String(format: "¥%.2f", NSString(string:price).floatValue/100)
        return newPrice
    }
    
    //获取当前时间
    class func getCurrentTimeMillis()-> String {
        let now = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyyMMddHHmmss"
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return String.init(timeStamp)
    }
    
    class func getCurrentYearMillis()-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyy"
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
    //获取当前小时
    class func getCurrentHoursMillis()-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH"
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
    //获取当前
    class func getCurrentSecondMillis()-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "SS"
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
    //时间字符串转化为时间戳
    class func stringToTimeStamp(stringTime:String)->String {
        let dfmatter = DateFormatter()
//        dfmatter.dateFormat="yyyy年MM月dd日HH:mm"
        dfmatter.dateFormat="yyyy年MM-dd-HH:mm"
        let date = dfmatter.date(from: stringTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return String(dateSt)
    }
    
    //时间戳转化为时间字符串
    class func timeStampToString(timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日HH:mm"
        let date = NSDate(timeIntervalSince1970: timeSta)
        print(dfmatter.string(from: date as Date))
        return dfmatter.string(from: date as Date)
    }
    
    //时间戳转化为时间字符串
    class func timeStampToFeedbackString(timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: timeSta)
        print(dfmatter.string(from: date as Date))
        return dfmatter.string(from: date as Date)
    }
    
    //创建二维码图片
    class func createQRForString(qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString{
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            //创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter?.outputImage
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
            let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
            
            // 中间一般放logo
            if let logoImage = qrImageName {
                if let iconImage = UIImage(named: logoImage) {
                    let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                    
                    UIGraphicsBeginImageContext(rect.size)
                    codeImage.draw(in: rect)
                    let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
                    
                    let x = (rect.width - avatarSize.width) * 0.5
                    let y = (rect.height - avatarSize.height) * 0.5
                    iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                    
                    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    UIGraphicsEndImageContext()
                    return resultImage
                }
            }
            return codeImage
        }
        return nil
    }
    
   class func setCrowdfundingPrice(_ price:NSNumber)->String{
        var newPrice = ""
        var ratio = 0
        var unit = ""
        if price.intValue < 10000 {
           ratio = 1
           unit = ""
        }else if (10000 <=  price.intValue) && (price.intValue < 100000000){
            ratio = 10000
            unit = "万"
        }else{
            ratio = 100000000
            unit = "亿"
        }
        newPrice = "\(price.intValue/ratio)" + ".00" + unit
        return newPrice
    }
    
    //读取归档
    class func getPlaceOnFile(_ file:String) ->AnyObject
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = (path as NSString).appendingPathComponent(file + ".plist")
        let data =  NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
        if data != nil {
             return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as AnyObject
        }else{
             return NSNull()
        }
    }
    
    //不使用四舍五入
    class func floorToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return floor(value * divisor) / divisor
    }
    
    //计算公里
    class func calculatingKilometre(value:NSNumber)->String{
        let km = value.floatValue
        if km < 1000 {
            return "1km"
        }else{
            let newKm = km/1000
            return String(format: "%.2f", newKm) + "km"
        }
    }

    //添加阴影
    class func setViewShadow(_ view:UIView){
        view.layer.shadowOpacity = 0.1
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width:2,height:4)
    }
    
    class func getPTNcoinNo()->String{
        return "40"
    }
    
    class func getPTNcoinNum()->NSNumber{
        return 40
    }
    
    //获取转账类型
//    class func getTransferStyle(style:String)->String{
//        if style == "0" {
//            return "转入"
//        }else if style == "1" {
//            return "转出"
//        }else{
//            return "--"
//        }
//    }
    
    //根据ID进行排序
//   class func sortByIDs(_ json:Any) -> Any{
//        let coinIdArray = UserDefaults.standard.object(forKey:R_UserDefaults_Market_Details_Edit_Key) as! NSArray
//        if coinIdArray.count == 0  {
//            return json
//        }
//        let object:NSDictionary = json as! NSDictionary
//        if (object.object(forKey: "data") != nil) {
//            let dataArray = object.object(forKey: "data") as! NSArray
//            if dataArray.count != 0 {
//                let newArray = NSMutableArray()
//                for item in 0...coinIdArray.count - 1 {
//                    let coinID:String = coinIdArray[item] as! String
//                    
//                    for item in 0...dataArray.count - 1 {
//                        let data = dataArray[item] as! NSDictionary
//                        let dataID = data.object(forKey: "coin_no") as! String
//                        if coinID.isEqual(dataID) {
//                            newArray.add(data)
//                        }
//                    }
//                }
//                let code = object["code"]
//                let msg = object["msg"]
//                let newjson = ["code":code,"msg":msg,"data":newArray]
//                return newjson
//            }else{
//                return json
//            }
//        }else{
//            return json
//        }
//    }
    
    class func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    //json转化为字典
   class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    class func DLog<T>(message: T, file: String = #file, method: String = #function ,line: Int = #line) {
        #if DEBUG
            print("<\((file as NSString).lastPathComponent):\(line)>,\(method),\(message)")
        #endif
    }
    
    class func getAppointTime(makeTime: String) -> String {
       
        let allTimeArray = ["7:00~10:00","11:00~14:00","15:00~19:00","21:00~00:00"]
        let index = Int(makeTime)! - 10
        var string = ""

        if index >= 0 && index < 4 {
            string = allTimeArray[index]
        }
        return string
    }
    
    class func switchToLoginViewController() {
        let loginvc = LoginController()
        let navi = FMNavigationController.init(rootViewController: loginvc)
        UIApplication.shared.keyWindow?.rootViewController = navi
    }
    
    class func switchToMainViewController() {
        
        let mainvc = MainTabBarController()
//        mainvc.selectedIndex = 3
        UIApplication.shared.keyWindow?.rootViewController = mainvc
    }
    
    class func cacheLoginData(token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.setValue(true, forKey: "hadLogin")
        UserDefaults.standard.synchronize()
        
    }
    
    class func removeCacheLoginData() {
        
        UserDefaults.standard.setValue("", forKey: "token")
        UserDefaults.standard.setValue(false, forKey: "hadLogin")
        UserDefaults.standard.synchronize()
        
    }
    
    class func setButtonType(isBoarder: Bool, sender: UIButton, fontSize: CGFloat, bgcolor: UIColor) {
        
        if isBoarder {
            sender.layer.borderColor = R_ZYPlaceholderColor.cgColor
            sender.layer.borderWidth = 1
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(R_ZYPlaceholderColor, for: .normal)
        } else {
            sender.layer.borderColor = bgcolor.cgColor
            sender.layer.borderWidth = 1
            sender.backgroundColor = bgcolor
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        
        sender.titleLabel?.font = UIFont.init(name: R_ThemeFontName, size: fontSize)
        sender.setViewBoarderCorner(radius: 5)

    }
    
    
    /// 将字典保存成本地沙盒Documents目录下json文件
    ///
    /// - Parameters:
    ///   - jsonDict: 数据字典
    ///   - fileName: Json文件名称
    class func storeJsonInDocuments(jsonDict: Dictionary<String, Any>, fileName: String) {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        
        do {
            //将json保存到本地
            let filePath:String = documentPath + "/" + fileName + ".json"
            let data : NSData! = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) as NSData!
            data.write(toFile: filePath, atomically: true)
            
            let loaddata = NSData(contentsOfFile: filePath)
            if loaddata != nil {
                let jData = loaddata! as Data
                let decoded = try JSONSerialization.jsonObject(with: jData, options: [])
                print("译码：",decoded)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //保存json字符串
    class func storeJsonInDocuments(jsonStr: String, fileName: String) {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        let filePath:String = documentPath + "/" + fileName + ".json"
        let data:NSData = jsonStr.data(using: String.Encoding.utf8)! as NSData
        data.write(toFile: filePath, atomically: true)
    }
    
    //保存归档
    class func savePlaceOnFile(_ file:String,_ data:Any)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = (path as NSString).appendingPathComponent(file + ".plist")
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
    
    
    /// 读取沙盒Documents文件夹下所有json格式文件
    ///
    /// - Returns: 所有json文件名称数组
    class func getJsonFileArrayInDocuments() -> NSMutableArray {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        let jsonFilePathArray = try? FileManager.default.subpathsOfDirectory(atPath: documentPath)
        let fileArray = NSMutableArray()
        if jsonFilePathArray != nil {
            for filePath in jsonFilePathArray! {
                let lastpath = filePath.components(separatedBy: "/").last
                if (lastpath?.contains(".json"))! {
                    fileArray.add(lastpath!)
                }
            }
        }
        return fileArray
    }
    
    class func getFileInDocuments() -> NSMutableArray {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        let filePathArray = try? FileManager.default.subpathsOfDirectory(atPath: documentPath)
        let fileArray = NSMutableArray()
        fileArray.addObjects(from: filePathArray!)
        return fileArray
    }
    
    
    /// 获取Document下json文件的json字符串
    ///
    /// - Parameter fileName: json文件名称，包含.json后缀
    /// - Returns: json文件内容，json字符串
    class func getJsonFileContentInDocuments(fileName: String) -> String {
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        let filePath:String = documentPath + "/" + fileName
        let loaddata = NSData(contentsOfFile: filePath)
        
        if loaddata != nil {
            let jData = loaddata! as Data
            let JSONString = NSString(data:jData,encoding: String.Encoding.utf8.rawValue)
            print("译码：",JSONString as Any)
            return JSONString! as String
        } else {
            return ""
        }
    }
    
    class func timeStampToString(timeStamp:Double)->String {

        let timeSta: TimeInterval = timeStamp
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.string(from: date as Date)
    }
    
    class func getWalletAmount(amount:String)->String{
        let strArray = amount.components(separatedBy: ".")
        if strArray.count == 1 {
            return strArray.first!
        }else{
            let price = strArray.first
            let point = strArray.last
            var newPoint = point
            if 7 < (point?.count)! {
                let index = point?.index((point?.startIndex)!, offsetBy: 8)
                newPoint = (point?.substring(to: index!))!
            }
            let amount = price! + "." + newPoint!
            return amount
        }
    }
    
    //0是中文英文
    class func getLocalLanguage()->String{
        let language = UserDefaults.standard.object(forKey: UserLanguage) as! String
        if language == "zh-Hans" {
           return "0"
        }else{
           return "1"
        }
    }
    
    //获取当前app 币种
    class func getAppCoinName()->String{
        return "PTN"
    }
    
    class func getIsChinese()->Bool{
        let language = UserDefaults.standard.object(forKey: UserLanguage) as! String
        if language == "zh-Hans" {
            return true
        }else{
            return false
        }
    }
    
    //获取C2C交易类型
    class func getBusinessaTransactionStyle(Style:String)->String{
        var transactionStatus = String()
        switch Style {
        case "0":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Matching")
        case "1":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Completed")
        case "2":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Cancelled")
        case "3":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Waiting_Buy_confirm")
        case "4":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Waiting_Sell_confirm")
        case "5":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Waiting_Cancel_auto")
        case "6":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Dispute")
        case "7":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Dispute_Money")
        case "8":
            transactionStatus = LanguageHelper.getString(key: "C2C_transaction_Dispute_Mis_Money")
        default: break
        }
        return transactionStatus
    }
    
   class func getBtcCoinNum()->String{
        return "10"
    }
    
    class func getPaymentMethod(_ paymentMethod:String)->String{
        if paymentMethod.contains(LanguageHelper.getString(key:"C2C_payment_Bankcard")){
            return "1"
        }else if paymentMethod.contains(LanguageHelper.getString(key: "C2C_payment_Alipay")){
            return "2"
        }else if paymentMethod.contains(LanguageHelper.getString(key: "C2C_payment_WeChat")){
            return "3"
        }else if paymentMethod.contains(LanguageHelper.getString(key: "C2C_payment_Other")){
            return "4"
        }
        return ""
    }
    
    class func getPaymentDetailsMethod(_ paymentMethod:String)->String{
        if paymentMethod.contains("1"){
            return LanguageHelper.getString(key:"C2C_payment_Bankcard")
        }else if paymentMethod.contains("2"){
            return LanguageHelper.getString(key: "C2C_payment_Alipay")
        }else if paymentMethod.contains("3"){
            return LanguageHelper.getString(key: "C2C_payment_WeChat")
        }else if paymentMethod.contains("4"){
            return LanguageHelper.getString(key: "C2C_payment_Other")
        }
        return ""
    }
    
    class func getMineAdvertisingMethod(_ advertisingType:String)->String{
        if advertisingType.contains("0"){
            return LanguageHelper.getString(key: "C2C_advertisement_status_Delegate")
        }else if advertisingType.contains("1"){
            return LanguageHelper.getString(key: "C2C_advertisement_status_Finish")
        }else if advertisingType.contains("2"){
            return LanguageHelper.getString(key: "C2C_advertisement_status_Drop")
        }else if advertisingType.contains("3"){
            return LanguageHelper.getString(key: "C2C_advertisement_status_Match")
        }
        return ""
    }
    
    //精确输入
    class func setAccurateData(data:NSNumber)->NSNumber{
        let str = data.stringValue
        let decimalNum = NSDecimalNumber(string: str)
        let decimalStr = decimalNum.stringValue
        let float = Float(decimalStr)
        let number = NSNumber(value: float!)
        return number
    }
    
    //金额显示
    class func setPriceNumber(price:NSNumber)->String{
        return String(format: "%.5f", price.floatValue)
    }
    
    class func getSubmissionDetailsStr(number:NSNumber)->String{
        if number == 0 {
           return LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Buy_did_not_pay")
        }else if number == 1 {
            return LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Seller_did_not_transfer")
        }else{
            return ""
        }
    }
    
    //没有设置支付密码状态值
    class func noPaymentPasswordSetCode()->NSNumber{
        return 300
    }
    
    //解决精度丢失
    class func setNSDecimalNumber(_ data:NSNumber)->String{
        let dataStr = String(format: "%lf", data.doubleValue)
        let deNum = NSDecimalNumber(string: dataStr)
        let deStr = (deNum.stringValue)
        return deStr
    }
    
    //没有设置支付密码执行操作
    class func noPaymentPasswordIsSetToExecute()->Bool{
        let password = UserDefaults.standard.getUserInfo().tradePasswordState
        if password == 0 || password == nil {
            let currentvc = OCTools.getCurrentVC()
            let setPwdVC = ModifyTradePwdViewController()
            setPwdVC.type = ModifyPwdType.tradepwd
            setPwdVC.isNeedNavi = false
            currentvc?.navigationController?.pushViewController(setPwdVC, animated: true)
            return false
        }
        return true
    }
    
    //保存交易密码
    class func saveTransactionPassword(password:String){
        if password != "" {
            let userInfo = UserDefaults.standard.getUserInfo()
            userInfo.tradePasswordState = 1
            UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
        }
    }
    
    /// 计算文本的宽度
    class func textHieght(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
    
    //计算文本宽度
    class func textWidth(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.width
    }
    
}


