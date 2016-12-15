//
//  CustomCellArticle.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/13/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import Kingfisher

class CustomCellArticle: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var articleImage: UIImageView!
    
    func configureCell(article: Article) {
        
        if let title = article.title {
            
            titleLabel.text = title.capitalized
        }
        if let description = article.description {
            
            descriptionLabel.text = description
        }
        
        if let imageURL = article.image {
            
            if let url = URL(string: imageURL) {
                print("image url response========\(url)")
                 articleImage.kf.setImage(with: url)
                
            } else {
                
                articleImage.image = UIImage(named: "nature")
            }
           
        }
        
        
    }
}
