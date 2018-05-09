//
//  MineViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/19.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper
import AVKit
import AssetsLibrary

class MineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topView: MineTopView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var contentArray = ["person_ad","person_Invite_friends","person_friend","perseon_safety","person_Feedback_record","perseon_settled","person_opinion","person_about","person_setup"]
    var imageArray = ["person_friend","ic_companySettled","person_friend","person_security","person_option","ic_companySettled","person_option","person_about","person_set_black"]
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviStyle()
        setViewStyle()
        getUserInfoByToken()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - EventResponse Method

    @objc func photoBtnTouched() {
        
        view.endEditing(true)
        
        let alertAction = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertAction.addAction(UIAlertAction.init(title: LanguageHelper.getString(key: "person_camera"), style: .default, handler: { (alertCamera) in
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .camera
            pickerVC.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.present(pickerVC, animated: true, completion: nil)
            } else {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "person_cameraenable"))
            }
            
        }))
        
        alertAction.addAction(UIAlertAction.init(title:LanguageHelper.getString(key: "person_photo"), style: .default, handler: { (alertPhoto) in
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .photoLibrary
            pickerVC.allowsEditing = true
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.present(pickerVC, animated: true, completion: nil)
            }  else {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "person_photoenable"))
                
            }
        }))
        
        alertAction.addAction(UIAlertAction.init(title:  LanguageHelper.getString(key: "login_cancle"), style: .cancel, handler: { (alertCancel) in
            
        }))
        
        self.present(alertAction, animated: true, completion: nil)
    }
    
    // MARK: - NetWork Method
    func modifyUserPhoto(photo: UIImage) {
        
        let token = SingleTon.shared.userInfo?.token!
//        let userno = SingleTon.shared.userInfo?.id!
        let params = ["token" : token!] as [String : Any]
        let jsonParameters =  Tools.getJSONStringFromDictionary(dictionary:params as NSDictionary)
        let requestParameters = ["data":jsonParameters]
        
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.uploadPictures(url: ZYConstAPI.kAPIUpdataUserPhoto, parameter: params, image: photo, imageKey: "photo", success: { (json) in
            Tools.DLog(message: params)
            let responseData = Mapper<NodataResponse>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  200 == code else {
                    SVProgressHUD.showError(withStatus: responseData?.message)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                if responseData?.data != nil {
                    SingleTon.shared.userInfo?.photo = responseData?.data!
                    self.topView.headImageView.sd_setImage(with: URL.init(string: (responseData?.data!)!), placeholderImage: UIImage.init(named: "ic_defaultPicture"))
                    
                    let userInfo = UserDefaults.standard.getUserInfo()
                    userInfo.photo = responseData?.data! as AnyObject
                    UserDefaults.standard.saveCustomObject(object: userInfo, key: R_UserInfo)
                }
            } else {
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
        
    }
    
    func getUserInfoByToken() {
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let params = ["token" : token]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIGetUserInfoByToken, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            SVProgressHUD.dismiss()
            let result = Mapper<LoginResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SingleTon.shared.userInfo = result?.data
                    UserDefaults.standard.setValue(result?.data?.username, forKey: "phone")
                    let dict = jsonObjc as! NSDictionary
                    if (dict.object(forKey: "data") != nil){
                        let userInfo = UserInfo(dict: dict.object(forKey: "data") as! [String : AnyObject])
                        UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                    }
                    Tools.cacheLoginData(token: (result?.data?.token)!)
                    self.setViewContent()
                } else {
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Delegate Method
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            modifyUserPhoto(photo: chosenImage)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MineViewTableViewCell", owner: nil, options: nil)?[0] as! MineViewTableViewCell
        cell.viewType = .arrow
        cell.leftImageView.image = UIImage.init(named: imageArray[indexPath.section])
        cell.leftLabel.text = LanguageHelper.getString(key: contentArray[indexPath.section])
        cell.rightImageView.image = UIImage.init(named: "person_rightarrow")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let businessaDvertisementVC = BusinessaDvertisementVC()
            self.navigationController?.pushViewController(businessaDvertisementVC, animated: true)
        case 1:
            let businessInviteFriendsVC = BusinessInviteFriendsVC()
            self.navigationController?.pushViewController(businessInviteFriendsVC, animated: true)
        case 2:
            let friendvc = FriendsViewController()
            self.navigationController?.pushViewController(friendvc, animated: true)
        case 3:
            let securityvc = SecuritySetViewController()
            self.navigationController?.pushViewController(securityvc, animated: true)
        case 4:
            let businessSubmissionMessageVC = BusinessSubmissionMessageVC()
            self.navigationController?.pushViewController(businessSubmissionMessageVC, animated: true)
        case 5:
            let certificationVC = HomeCertificationVC()
            self.navigationController?.pushViewController(certificationVC, animated: true)
        case 6:
            let opinionvc = OpitionViewController()
            self.navigationController?.pushViewController(opinionvc, animated: true)
        case 7:
            let aboutvc = AboutUsViewController()
            self.navigationController?.pushViewController(aboutvc, animated: true)
        case 8:
            let setvc = SystemSeUpViewController()
            self.navigationController?.pushViewController(setvc, animated: true)
        default:
            break
        }
        
        
    }
    
    // MARK: - Private Method
    func setNaviStyle() {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationController?.navigationBar.isHidden = true
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func setViewStyle() {
        
        topView.headEditBtn.addTarget(self, action: #selector(MineViewController.photoBtnTouched), for: .touchUpInside)
        
        topView.setBuyBtnBlock { (sender) in
            let businessBuyVC = BusinessBuyHistoryVC()
            businessBuyVC.transactionStyle = .buyStyle
            self.navigationController?.pushViewController(businessBuyVC, animated: true)
        }
        
        topView.setSellBtnBlock { (sender) in
            let businessSellVC = BusinessBuyHistoryVC()
            businessSellVC.transactionStyle = .sellStyle
            self.navigationController?.pushViewController(businessSellVC, animated: true)
        }
        
        topView.buyBtn.setTitle(LanguageHelper.getString(key: "person_buyad"), for: .normal)
        topView.sellBtn.setTitle(LanguageHelper.getString(key: "person_sellad"), for: .normal)

    }
    
    func setViewContent() {
        topView.headImageView.image = UIImage.init(named: "ic_defaultPicture")
        if SingleTon.shared.userInfo != nil {
            if let photo = SingleTon.shared.userInfo?.photo {
                let url = URL.init(string: photo)
                topView.headImageView.sd_setImage(with: url!, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            }
            
            if let nickname = SingleTon.shared.userInfo?.nickname {
                topView.nameTextFeild.text = nickname
            }
            
        }
    }
    
    

}
