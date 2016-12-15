//
//  ArticlePresenter.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/13/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import Foundation

class ArticlePresenter {
    
    var articlePresenterInterface: ArticlePresenterInterface?
    var articleUploadImageToServer: ArticleUploadImageToServer?
    let articleCRUDService = ArticleCRUDService()
    
    
    func loadArticles(search: String, page: Int, limit: Int) {
       
      
        articleCRUDService.delegate = self
        
        articleCRUDService.loadArticlesWithData(search: search, page: page, limit: limit)
        
    }
    
    func uploadSingleImageToServer(data:Data){
        
        articleCRUDService.articleUplodSingleImage = self
        articleCRUDService.uploadImage(data: data)
        
    }
    
    func postDataToService(datajson: Article){
        
        articleCRUDService.delegate = self
        articleCRUDService.sendArticleToServer(article: datajson)
    }
    
}

extension ArticlePresenter: ArticleCRUDServiceInterface, ArticleUplodSingleImage {
    
    func responseWithArticle(articles: [Article]) {
        
        if articles.count > 0 {
            
            articlePresenterInterface?.completeRequestArticle(articles: articles)
        }
        
        else {
            
            print("DATA NOT FOUND!")
        } 
        
    }
    
    func uploadSingleImageFromServiceComplete(imageURL: String) {
        
        articleUploadImageToServer?.uploadImageCompleted(data: imageURL)
    }
    
    func completeSendDataToService() {
        
        articleUploadImageToServer?.postDataCompleted()
        
        
    }
}
