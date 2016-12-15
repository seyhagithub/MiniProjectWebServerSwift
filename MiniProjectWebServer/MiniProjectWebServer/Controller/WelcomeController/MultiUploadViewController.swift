//
//  MultiUploadViewController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/11/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit

class MultiUploadViewController: UIViewController {

    @IBAction func goToMulitUploadVCButton(_ sender: Any) {
        
       present(UIStoryboard(name: "MultiUpload", bundle: nil).instantiateViewController(withIdentifier: "multiUploadST") as UIViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   

}
