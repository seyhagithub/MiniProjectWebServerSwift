//
//  ArticleCRUDServiceInterface.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/13/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import Foundation

protocol ArticleCRUDServiceInterface {
    
    func responseWithArticle(articles: [Article])
    
    func completeSendDataToService()
    
}

protocol ArticleUplodSingleImage {
    
      func uploadSingleImageFromServiceComplete(imageURL:String)
}
