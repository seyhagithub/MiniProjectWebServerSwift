//
//  MultiUploadImageTableViewController.swift
//  UploadMultiImageFileToServer
//
//  Created by Hiem Seyha on 12/9/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import DKImagePickerController
import Alamofire

class MultiUploadImageTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func backToMainButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var myTableView: UITableView!

    let pickerController = DKImagePickerController()
    var imageAsset:[DKAsset]!
    var tempAsset:[DKAsset]!
    
    var imagePath:[URL] = [URL]()
    
    var fileUIImage: [UIImage] = [UIImage]()
    
    
    let headers: HTTPHeaders = [
        "Authorization": "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
        "Accept": "application/json"
    ]
    
    @IBAction func browseImageButton(_ sender: Any) {
        
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            print("=========didSelectAssets============")
            print(assets)
            
            for asset in assets {

                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in

                    self.fileUIImage.append(image!)
                    self.myTableView.reloadData()
                    
                    self.imagePath.append(info!["PHImageFileURLKey"] as! URL)
 
                })
            }
        }
        
        present(pickerController, animated: true, completion: {
            
            self.pickerController.deselectAllAssets()
        })
        
    }
    
    @IBAction func uploadMultiImageButton(_ sender: Any) {
        
        print("uploading.............")
        
        
        Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                   
                    for fileImage in self.fileUIImage {
                        
                        multipartFormData.append(UIImageJPEGRepresentation(fileImage, 0.6)!, withName: "files", fileName:"image.jpg", mimeType: "image/jpg")
                    }
                    
                    multipartFormData.append("restaurant".data(using: .utf8)!, withName: "name")
                    
            },
                
                to: "http://120.136.24.174:15020/v1/api/admin/upload/multiple",
                method: HTTPMethod(rawValue: "POST")!,
                headers: headers,
                
                
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
        )

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fileUIImage.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
        
        cell.fileImageview.image = fileUIImage[indexPath.row]
        cell.pathImageLabel.text = imagePath[indexPath.row].description
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            imagePath.remove(at: indexPath.row)
            fileUIImage.remove(at: indexPath.row)
            
        }
        
        myTableView.reloadData()
    }
    

}
