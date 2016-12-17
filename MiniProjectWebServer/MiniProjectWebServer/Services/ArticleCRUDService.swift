//
//  ArticleCRUDService.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/11/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import Foundation
import UIKit

class ArticleCRUDService {
    //MARK: =============== Global Variable  ==================
    var articles: [Article] = [Article]()
    var pagination: Pagination!
    var delegate:ArticleCRUDServiceInterface?
    var articleUplodSingleImage: ArticleUplodSingleImage?

    //MARK: =============== Load Article From Server  ==================
    func loadArticlesWithData(search:String, page:Int, limit:Int) {
        
        // =========== clear old value ===========
        articles = [Article]()
        
        print("Download Started...\(search)")
    
        let url = URL(string: "\(Constant.ArticleManagment.BASE_URL)?title=\(search.replacingOccurrences(of: " ", with: "%20"))&page=\(page)&limit=\(limit)")
        
                
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.addValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in

            if error == nil {
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject] {
                    
                    let jsonDATA = json["DATA"] as! [AnyObject]
                    
                    let paginationDATA = json["PAGINATION"] as! [String:Any]
                    self.pagination = Pagination(JSON: paginationDATA)
                    
                    print("================pagination=========")
                    
                    print(self.pagination)
                    
                    for data in jsonDATA {
                        
                        self.articles.append(Article(JSON: data as! [String: Any])!)
                    }
                    
                    //====== Notify Respose Data Function ============
                    self.delegate?.responseWithArticle(articles: self.articles, pagination:self.pagination)
                }
                
            }
            
        })
        
        task.resume()
        
    }
    
    //MARK: ================ Send Article to Server ==================
    
    func sendArticleToServer(article: Article) {
        
        do {
            
           let jsonString = article.toJSONString()
            print("jsong ========= \(jsonString)")
           
            let endpoint: String = Constant.ArticleManagment.BASE_URL
            let session = URLSession.shared
            let url = NSURL(string: endpoint)!
            let request = NSMutableURLRequest(url: url as URL)
            
            request.addValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // insert json data to the request
   
            request.httpBody = jsonString?.data(using: .utf8)
            
            let task = session.dataTask(with: request as URLRequest){ data,response,error in
               
                if error != nil{
                    
                    print("\(error?.localizedDescription)")
                    return
                    
                }
            }
            
           task.resume()
            
        } catch {
            
            print("bad things happened")
        }
        
        
        
        //========= Notify to Prensenter
        
        delegate?.completeSendDataToService()
    }
    //MARK: ============= Upload Image to Server =============
    func uploadImage(data: Data) {
        
        let url = URL(string: Constant.ArticleManagment.BASE_URL_SINGLE_IMAGE)
        var request = URLRequest(url: url!)
        
        // Set method
        request.httpMethod = "POST"
       
       request.setValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
        
         // Set boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create requestBody
        var formData = Data()
    
        let mimeType = "image/png" // Multipurpose Internet Mail Extension
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(data)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = formData
        
        print(formData)
        
        
        let uploadTask = URLSession.shared.dataTask(with: request){
            
            data, response, error in
            
            var jsonData: String?
            
            if error == nil{
                
                print("Success : \(response)")
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    jsonData = json["DATA"] as? String
                    
                }catch let error {
                    
                    print("Error : \(error.localizedDescription)")
                }
                
                self.articleUplodSingleImage?.uploadSingleImageFromServiceComplete(imageURL: jsonData!)
                
            }else{
            
                print("\(error?.localizedDescription)")
            }
            
        }
        
        uploadTask.resume()
        
    }
    
    //MARK: ==================== Delete Row From Article ================
    
    func deleteArticleService(article_id: Int) {
        
        let url = "\(Constant.ArticleManagment.BASE_URL)/\(article_id)"
        
        print("url ======== delete ======= \(url)")
        
        var request = URLRequest(url: URL(string: url)!)
        
         request.setValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard let _ = data else {
                print("error calling DELETE on /Article")
                return
            }
            
            print("DELETE ok")
            self.delegate?.deleteArticleCompleteFromService()
            
        }
        task.resume()
        
    }
    
    
    //MARK: ================ Update Article to server ==================
    
    func updateArticleToServer(article: Article) {
        do {
            
            let jsonString = article.toJSONString()
            print("jsong ========= \(jsonString)")
            //print("sending data \(jsonData)")
            // create post request
            let endpoint: String = "\(Constant.ArticleManagment.BASE_URL)/\(article.id)"
            let session = URLSession.shared
            let url = NSURL(string: endpoint)!
            let request = NSMutableURLRequest(url: url as URL)
            
            request.addValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
            
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // insert json data to the request
            
            request.httpBody = jsonString?.data(using: .utf8)
            
            let task = session.dataTask(with: request as URLRequest){ data,response,error in
                
                if error != nil{
                    
                    print("\(error?.localizedDescription)")
                    return
                    
                }
            }
            
            task.resume()
            
        } catch {
            
            print("bad things happened")
        }
        
        //========= Notify to Prensenter
        
        delegate?.updateArticleCompleteFromService()
    }

    
}
