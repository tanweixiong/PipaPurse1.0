//
//  ActivateInformationVC.swift
//  DHSWallet
//
//  Created by tam on 2018/4/24.
//  Copyright © 2018年 zhengyi. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import ObjectMapper

protocol ActivateInformationDelegate {
    func activateInformationModifiedFinish()
}

class ActivateInformationVC: MainViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    enum ActivateInformationStyle{
        case address
        case nickName}
    fileprivate let headingArr = ["更改头像","昵称修改"]
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    fileprivate let contentArr = NSMutableArray(array: ["","",""])
    fileprivate let activateInformationCell = "ActivateInformationCell"
    fileprivate let avatarBtn = UIButton()
    fileprivate var nicknameTF = UITextField()
    fileprivate var addresTF = UITextField()
    fileprivate var token = (UserDefaults.standard.getUserInfo().token)!
    fileprivate var style = ActivateInformationStyle.address
    fileprivate var isEditAddress = false
    fileprivate var isEditNickname = false
    
    var delegate:ActivateInformationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserInfo()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ActivateInformationCell", bundle: nil),forCellReuseIdentifier: self.activateInformationCell)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
        if isEditAddress && isEditNickname {
            self.changeAddressOrNickname(style: .address)
            self.changeAddressOrNickname(style: .nickName)
        }else if isEditAddress {
            self.changeAddressOrNickname(style: .address)
        }else if isEditNickname {
            self.changeAddressOrNickname(style: .nickName)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
}

extension ActivateInformationVC {
    func setupUI(){
        setNormalNaviBar(title: "个人资料")
        view.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(self.greetingTextFieldChanged), name:NSNotification.Name.UITextFieldTextDidChange,object: nil)
    }
    
    @objc func greetingTextFieldChanged(obj: Notification) {
        let textField: UITextField = obj.object as! UITextField
        guard let _: UITextRange = textField.markedTextRange else{
            if (textField.text! as NSString).length > 20{
                textField.text = (textField.text! as NSString).substring(to: 20)
            }
            return
        }
    }
    
    func getUserInfo(){
        if let photo = UserDefaults.standard.getUserInfo().photo {
            contentArr.replaceObject(at: 0, with: photo)
        }
        
        if let nickname = UserDefaults.standard.getUserInfo().nickname {
            contentArr.replaceObject(at: 1, with: nickname)
        }
        
        if let address = UserDefaults.standard.getUserInfo().address {
             contentArr.replaceObject(at: 2, with: address)
        }
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
                    let userInfo = UserDefaults.standard.getUserInfo()
                    userInfo.photo = responseData?.data! as AnyObject
                    UserDefaults.standard.saveCustomObject(object: userInfo, key: R_UserInfo)
                    self.delegate?.activateInformationModifiedFinish()
                    self.tableView.reloadData()
                }
            } else {
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
    }
    
    //修改地址或者
    func changeAddressOrNickname(style:ActivateInformationStyle){
        let url = style == .address ? ZYConstAPI.kAPISetUserAddress :  ZYConstAPI.kAPISetNickName
        let dict = NSMutableDictionary(dictionary: ["token":self.token])
        dict.addEntries(from: style == .address ? ["address":addresTF.text!] : ["nickName":nicknameTF.text!])
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: url, parameters: (dict as! [String : Any]), showIndicator: false) { (model:HomeBaseModel) in
            let userInfo = UserDefaults.standard.getUserInfo()
            if style == .address {
                userInfo.address = model.data as? String
            }else if style == .nickName {
                userInfo.nickname = model.data as AnyObject
            }
            UserDefaults.standard.saveCustomObject(object: userInfo, key: R_UserInfo)
            self.delegate?.activateInformationModifiedFinish()
        }
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.addresTF {
            self.isEditAddress = true
        }else if textField == self.nicknameTF {
            self.isEditNickname = true
        }
        return true
    }
    
   @objc func uploadImageOnClick(_ sender:UIButton){
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.uploadpictures(image: OCTools.getSubImage(chosenImage, mCGRect: CGRect(x: 0, y: 0, width: 100, height: 100), center: false))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         view.endEditing(true)
         return true
    }
}

extension ActivateInformationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activateInformationCell, for: indexPath) as! ActivateInformationCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.iconBtn.addTarget(self, action: #selector(uploadImageOnClick(_:)), for: .touchUpInside)
            cell.textfield.isHidden = true
            cell.iconBtn.isHidden = false
            cell.avatarImg.isHidden = false
            var photo = String()
            if UserDefaults.standard.getUserInfo().photo != nil {
                photo = (UserDefaults.standard.getUserInfo().photo)! as! String
            }
            cell.avatarImg.sd_setImage(with:NSURL(string: photo)! as URL, placeholderImage: UIImage.init(named: "ic_mine_avatar"))
            cell.headingLab.text = headingArr[indexPath.row]
        }else{
            cell.headingLab.text = headingArr[indexPath.row]
            cell.textfield.text = contentArr[indexPath.row] as? String
            cell.textfield.placeholder = LanguageHelper.getString(key: "Mine_Please_enter_a_nickname")
            cell.textfield.delegate = self
            cell.textfield.returnKeyType = .done
            if indexPath.row == 1 {
                nicknameTF = cell.textfield
            }else if indexPath.row == 2 {
                addresTF = cell.textfield
                cell.textfield.isUserInteractionEnabled = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            BRAddressPickerView.showAddressPicker(withDefaultSelected: [10, 1, 1], isAutoSelect: true, resultBlock: { (address:Any) in
                let arr = address as! NSArray
                self.addresTF.text = "\((arr.firstObject)!)" + "·" + "\((arr.lastObject)!)"
                self.isEditAddress = true
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         view.endEditing(true)
    }
}
