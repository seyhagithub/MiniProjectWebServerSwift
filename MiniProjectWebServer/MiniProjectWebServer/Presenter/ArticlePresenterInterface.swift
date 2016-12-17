//
//  ArticlePresenterInterface.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/13/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import Foundation

protocol ArticlePresenterInterface {
    
    func completeRequestArticle(articles: [Article], pagination:Pagination)
    
    func deleteArticleComplete()
}

protocol ArticleUploadImageToServer{
    
    func uploadImageCompleted(data:String)
    
    func postDataCompleted()
    
    func updateArticleComplete()
    

}