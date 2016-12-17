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
    var article: Article!
    
    //========================
    func loadArticles(search: String, page: Int, limit: Int) {
       
      
        articleCRUDService.delegate = self
        
        articleCRUDService.loadArticlesWithData(search: search, page: page, limit: limit)
        
    }
    
    func uploadSingleImageToServer(data:Data){
        
        articleCRUDService.articleUplodSingleImage = self
        articleCRUDService.uploadImage(data: data)
        
    }
    
    //=============== update article =============
    
    func updateArticleToService(article: Article, data: Data){
        
        self.article = article
        uploadSingleImageToServer(data: data)
       
        
    }
    
    func postDataToService(datajson: Article){
        
        articleCRUDService.delegate = self
        articleCRUDService.sendArticleToServer(article: datajson)
    }
    
    func deleteArticle(article_id: Int){
        
        articleCRUDService.delegate = self
        articleCRUDService.deleteArticleService(article_id: article_id)
    }
    
    
}

extension ArticlePresenter: ArticleCRUDServiceInterface, ArticleUplodSingleImage {
    
    //MARK: ================ NOTIFY ===============
    func responseWithArticle(articles: [Article], pagination:Pagination) {
        
        if articles.count > 0 {
            
            articlePresenterInterface?.completeRequestArticle(articles: articles, pagination: pagination)
        }
        
        else {
            
            print("DATA NOT FOUND!")
        } 
        
    }
    
    func uploadSingleImageFromServiceComplete(imageURL: String) {
        
        articleUploadImageToServer?.uploadImageCompleted(data: imageURL)
        
        if self.article != nil {
            
            self.article.image = imageURL
            
            print("====== article with image url =====")
            print(article.image)
//            articleCRUDService.delegate = self
//            articleCRUDService.updateArticleToServer(article: article)
        }

    }
    
    func completeSendDataToService() {
        
        articleUploadImageToServer?.postDataCompleted()
        
    }
    
    func deleteArticleCompleteFromService() {
        
        print("deleted service")
        articlePresenterInterface?.deleteArticleComplete()
    }
    
    func updateArticleCompleteFromService() {
        
       articleUploadImageToServer?.updateArticleComplete()
    }
}
