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
import Alamofire

class MineViewController: UIViewController {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var usernameLab: UILabel!
    
    @IBOutlet weak var miningLab: UILabel!
    @IBOutlet weak var myAdvertisementLab: UILabel!
    @IBOutlet weak var advertisingRecordsLab: UILabel!
    @IBOutlet weak var inviteFriendsLab: UILabel!
    @IBOutlet weak var aBoutUsLab: UILabel!
    @IBOutlet weak var securitySettingsLab: UILabel!
    let newImage = UIImageView()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviStyle()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    lazy var avatarImageVw: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage.init(named: "ic_defaultPicture")
//        imageView.frame = CGRect(x: 15, y: 20, width: 80, height: 80)
//        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = 40
//        return imageView
//    }()
    
    @IBAction func onClick(_ sender: UIButton) {
        //挖矿
        if sender.tag == 1 {
            let mineMiningVC = MineMiningVC()
            self.navigationController?.pushViewController(mineMiningVC, animated: true)
        }else if sender.tag == 2 {
            let businessBuyVC = BusinessBuyHistoryVC()
            businessBuyVC.transactionStyle = .buyStyle
            self.navigationController?.pushViewController(businessBuyVC, animated: true)
        }else if sender.tag == 3 {
            let businessaDvertisementVC = BusinessaDvertisementVC()
            self.navigationController?.pushViewController(businessaDvertisementVC, animated: true)
        }else if sender.tag == 4 {
            let businessInviteFriendsVC = BusinessInviteFriendsVC()
            self.navigationController?.pushViewController(businessInviteFriendsVC, animated: true)
        }else if sender.tag == 5 {
            let aboutvc = AboutUsViewController()
            self.navigationController?.pushViewController(aboutvc, animated: true)
        }else if sender.tag == 6 {
            let securitySetViewController = SecuritySetViewController()
            self.navigationController?.pushViewController(securitySetViewController, animated: true)
        }else if sender.tag == 7 {
            let activateInformationVC = ActivateInformationVC()
            activateInformationVC.delegate = self
            self.navigationController?.pushViewController(activateInformationVC, animated: true)
        }else if sender.tag == 8 {
            uploadImage()
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
        
        miningLab.text = LanguageHelper.getString(key: "Mine_Mining")
        myAdvertisementLab.text = LanguageHelper.getString(key: "Mine_MyAdvertisement")
        advertisingRecordsLab.text = LanguageHelper.getString(key: "Mine_AdvertisingRecords")
        inviteFriendsLab.text = LanguageHelper.getString(key: "Mine_InviteFriends")
        aBoutUsLab.text = LanguageHelper.getString(key: "Mine_ABoutUs")
        securitySettingsLab.text = LanguageHelper.getString(key: "Mine_SecuritySettings")
    }
    
    func getData(){
         usernameLab.text = "--"
        if let nickname = UserDefaults.standard.getUserInfo().nickname {
            usernameLab.text = (nickname as! String) == "" ? "--" : (nickname as! String)
        }
        
        if let photo = UserDefaults.standard.getUserInfo().photo {
             photoImg.sd_setImage(with: (NSURL(string: photo as! String)! as URL), placeholderImage: UIImage(named: "ic_mine_avatar")) { (image, error, cacheType, url) -> Void in
                
            }
        }
    }
    
    func uploadImage(){
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
    
    //上传图片
    func uploadpictures(image:UIImage) {
        let token = (UserDefaults.standard.getUserInfo().token)!
        let params = ["token" : token] as [String : Any]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.uploadPictures(url: ZYConstAPI.kAPIUpdataUserPhoto, parameter: params, image: image, imageKey: "photo", success: { (json) in
            Tools.DLog(message: params)
            let responseData = Mapper<NodataResponse>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  200 == code else {
                    SVProgressHUD.showError(withStatus: responseData?.message)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                if responseData?.data != nil {
                    self.photoImg.image =  OCTools.getSubImage(image, mCGRect:  CGRect(x: 0, y: 0, width: 500, height: 500), center: false)
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
}

extension MineViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.uploadpictures(image: chosenImage)
        }
    }
}

extension MineViewController:ActivateInformationDelegate{
    func activateInformationModifiedFinish() {
         getData()
    }
}
