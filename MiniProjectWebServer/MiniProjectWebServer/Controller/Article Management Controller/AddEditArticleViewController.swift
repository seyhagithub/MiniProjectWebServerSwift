//
//  AddEditArticleViewController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/15/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
class AddEditArticleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var authorLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var facebookIDLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    
    var articlePresenter = ArticlePresenter()
    var article: Article!
    
    var imageData: String?
    
    var datajson: [String:Any]!
    
    @IBAction func saveButton(_ sender: Any) {
        
         HUD.show(.progress)
        
        if article == nil {
        
            articlePresenter.articleUploadImageToServer = self
            
            let myImage = UIImagePNGRepresentation(articleImageView.image!)
            print("image view \(myImage)")
            
            articlePresenter.uploadSingleImageToServer(data:myImage!)
            
        } else {
            
            let data = UIImagePNGRepresentation(articleImageView.image!)
            if let title = titleLabel.text, let description =  descriptionTextView.text  {
                
                
                datajson = [
                    
                    "TITLE": title,
                    "DESCRIPTION": description,
                    "AUTHOR": 0,
                    "CATEGORY_ID" : 0,
                    "STATUS": "string",
                    "IMAGE": ""
                ]
                
            }
            
            let art = Article(JSON: datajson)
            
            articlePresenter.articleUploadImageToServer = self
            articlePresenter.updateArticleToService(article: art!,data: data!)
        }
        
    }

    var imagePickerView = UIImagePickerController()
    
    @IBAction func browseImageViewButton(_ sender: Any) {
        
        imagePickerView.delegate = self
        imagePickerView.sourceType = .photoLibrary
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.funcCameraButton()
        }
        
        let gallaryAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            
            //self.browseImageGalleryButton(self.browseImageGallery)
            self.funcBrowseImageGalleryButton()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePickerView.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if article != nil {
            
            if let title = article.title {
                
                titleLabel.text = title
            }
            if let name = article.author?.name {
                
                  authorLabel.text = name
            }
            if let facebook_id = article.author?.facebook_id {
                
                 facebookIDLabel.text = facebook_id
            }
            if let description = article.description {
                
                descriptionTextView.text = description
            } else {
                
                descriptionTextView.text = ""
            }
            if let email = article.author?.email {
                 emailLabel.text = email
                
            }
            if let imageURL = article.image {
                
                if let url = URL(string: imageURL) {
                    print("image url response========\(url)")
                    articleImageView.kf.setImage(with: url)
                    
                } else {
                    
                    articleImageView.image = UIImage(named: "nature")
                }
                
            }
        }

    }

}

extension AddEditArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, ArticleUploadImageToServer {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imagePathPNG = UIImagePNGRepresentation(image)
        
        //imagePath = imagePathPNG
        articleImageView.image = image
        print("imagepathPnag \(imagePathPNG)")
        
        imagePickerView.dismiss(animated: true, completion: nil)
        
    }
    
    func funcBrowseImageGalleryButton() {
        
        imagePickerView.delegate = self
        imagePickerView.sourceType = .photoLibrary
        present(imagePickerView, animated: true, completion: nil)
    }
    
    func funcCameraButton() {
        
        imagePickerView.delegate = self
        imagePickerView.sourceType = .camera
        imagePickerView.cameraCaptureMode = .photo
        imagePickerView.modalPresentationStyle = .fullScreen
        
        present(imagePickerView, animated: true, completion: nil)
    }
    
    func uploadImageCompleted(data: String) {
        
        imageData = data

        print("image url sucess ==== \(data)")
        
        if let title = titleLabel.text, let description =  descriptionTextView.text {
            
            datajson = [
                
                "TITLE": title,
                "DESCRIPTION": description,
                "AUTHOR": 0,
                "CATEGORY_ID" : 0,
                "STATUS": "string",
                "IMAGE": data
            ]
            
        }
        
         let art = Article(JSON: datajson)
        
        print("datajson====================\(datajson)")
        
        articlePresenter.articleUploadImageToServer = self
        
        articlePresenter.postDataToService(datajson: art!)
    }
    
        
    func postDataCompleted() {
        
        
        DispatchQueue.main.async {
            HUD.hide()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func updateArticleComplete() {
        
        
        print("update completed")
        DispatchQueue.main.async {
             HUD.hide()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
}
