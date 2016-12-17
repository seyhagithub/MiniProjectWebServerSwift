//
//  DetailArticleViewController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/14/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import Kingfisher

class DetailArticleViewController: UIViewController {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleArticleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var facebookBarButtonToolbar: UIBarButtonItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if article != nil {
            
            print("not nil")
            titleArticleLabel.text = article.title?.capitalized
            authorLabel.text = "Author: \(article.author?.name)".capitalized
            emailLabel.text = "Email: \(article.author?.email)"
            facebookBarButtonToolbar.title = "Facebook ID: \(article.author?.facebook_id)"
            descriptionTextView.text = article.description
            
            if let imageURL = article.image {
                
                if let url = URL(string: imageURL) {
                    
                    articleImageView.kf.setImage(with: url, placeholder: UIImage(named: "nature"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            
        } else {
            
            print("nil")
        }
        
    }

    
    

  
}
