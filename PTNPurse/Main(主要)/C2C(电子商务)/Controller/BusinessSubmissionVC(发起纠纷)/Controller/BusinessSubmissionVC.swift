//
//  BusinessSubmissionVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/22.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class BusinessSubmissionVC: MainViewController,UITextViewDelegate {
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    fileprivate let imageArray = NSMutableArray()
    fileprivate var complaintStyle = String()
    fileprivate var btnRect = CGRect()
    fileprivate var btnNum = 1
    var orderNo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight)
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var submissionVw: BusinessSubmissionVw = {
        let view = Bundle.main.loadNibNamed("BusinessSubmissionVw", owner: nil, options: nil)?.last as! BusinessSubmissionVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 395)
        view.complaintBtn.addTarget(self, action: #selector(complaintOnClick(_:)), for: .touchUpInside)
        view.addPhotoBtn.addTarget(self, action: #selector(photoBtnTouched), for: .touchUpInside)
        view.addPhotoBtn.tag = 1
        view.complaintTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        view.complaintTF.font = UIFont.systemFont(ofSize: 12)
        view.descriptionTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        view.descriptionTF.font = UIFont.systemFont(ofSize: 12)
        view.descriptionTF.delegate = self
        view.uploadImgTitleLab.text = LanguageHelper.getString(key: "C2C_Upload_certificate")
        view.InstructionsTitleLab.text = LanguageHelper.getString(key: "C2C_Upload_Instructions")
        view.reasonLab.text =  LanguageHelper.getString(key: "C2C_Upload_reason")
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessSubmissionVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: view.complaintTF)
        return view
    }()
    
    lazy var submitBtn:UIButton = {
        let button = UIButton(frame: CGRect(x: 15, y: submissionVw.frame.maxY + 15, width: SCREEN_WIDTH - 30, height: 50))
        button.setTitle(LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Submit_a_complaint"), for: .normal)
        button.backgroundColor = R_UIThemeColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(BusinessSubmissionVC.submitPost), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        return button
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        if OCTools.isPositionTextViewDidChange(textView) && textView == submissionVw.descriptionTF {
            let textContent = textView.text
            let textNum = textContent?.count
            if textNum! > 100 {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: 100)
                let str = textContent?.substring(to: index!)
                textView.text = str
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_Upload_Limit_input"))
            }
            setSubmitBtnStyle()
        }
    }
    
    @objc func textFieldTextDidChangeOneCI(noti:NSNotification){
        let tf = noti.object as! UITextField
        if tf == submissionVw.complaintTF {setSubmitBtnStyle()}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusinessSubmissionVC {
    
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Complaint_application"))
        view.addSubview(scrollView)
        scrollView.addSubview(submissionVw)
        scrollView.addSubview(submitBtn)
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 100)
        btnRect = self.submissionVw.addPhotoBtn.frame
        setSubmitBtnStyle()
    }
    
   @objc func submitPost() {
        if imageArray.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_Please_upload_pictures"))
            return
        }
        let token = (UserDefaults.standard.getUserInfo().token)!
        let remark = self.submissionVw.descriptionTF.text!
        let type = complaintStyle
        let orderNo = self.orderNo
        let language = Tools.getLocalLanguage()
        let parameters = ["orderNo":orderNo,"token":token,"remark":remark,"type":type,"language":language]
       ZYNetWorkTool.uploadMuchPictures(url: ZYConstAPI.kAPISpotDisputeSubmission, parameter: parameters, imageArray: self.imageArray, imageKey: "photo", success: { (json) in
        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Uploaded_successfully"))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationC2COrderReload), object: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.navigationController?.popViewController(animated: true)
         })
          }) { (error) in
          }
    }
    
    func uploadImage(_ image:UIImage){
        self.imageArray.add(image)
        self.addBtn(image)
    }
    
    func setSubmitBtnStyle(){
        if submissionVw.complaintTF.text != "" && submissionVw.descriptionTF.text != ""  {
            submitBtn.isSelected = true
        }else{
            submitBtn.isSelected = false
        }
        
        if submitBtn.isSelected {
            submitBtn.backgroundColor = R_UIThemeColor
            submitBtn.setTitleColor(UIColor.white, for: .normal)
            submitBtn.layer.borderWidth = 0
            submitBtn.isEnabled = true
        }else{
            submitBtn.backgroundColor = UIColor.clear
            submitBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCED7E6), for: .normal)
            submitBtn.layer.borderWidth = 1
            submitBtn.isEnabled = false
        }
    }
    
   @objc func complaintOnClick(_ sender:UIButton){
    let array = [LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Buy_did_not_pay"), LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Seller_did_not_transfer")]
    BRStringPickerView.showStringPicker(withTitle: LanguageHelper.getString(key: "C2C_publish_order_Please_select_your_receiving_method"), dataSource:array
     , defaultSelValue: nil, isAutoSelect: false, resultBlock: { (method:Any) in
            let str = method as! String
            self.submissionVw.complaintTF.text = str
            if array.first == str {
                self.complaintStyle = "0"
             }else{
                self.complaintStyle = "1"
             }
       })
    }
    
   @objc func addBtn(_ image:UIImage){
        let btn = UIButton(frame: CGRect(x: btnRect.origin.x + btnRect.size.width + 15  , y:btnRect.origin.y , width: btnRect.size.width, height: btnRect.size.height))
        btn.addTarget(self, action: #selector(photoBtnTouched), for: .touchUpInside)
        btn.setBackgroundImage(UIImage.init(named: "ic_mine_addImg"), for: .normal)
        submissionVw.addPhotoVw.addSubview(btn)
        let newBtn = submissionVw.addPhotoVw.viewWithTag(btnNum) as! UIButton
        newBtn.setBackgroundImage(image, for: .normal)
        btnNum = btnNum + 1
        btn.tag = btnNum
        btnRect = btn.frame
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         closeKeyboard()
    }
    
}

extension BusinessSubmissionVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func photoBtnTouched() {
        if btnNum == 4 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Can_add_more"))
            return
        }
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.uploadImage(chosenImage)
        }
    }
}




