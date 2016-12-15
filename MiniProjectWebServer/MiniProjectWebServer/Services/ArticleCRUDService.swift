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

    var articles: [Article] = [Article]()
    
    var delegate:ArticleCRUDServiceInterface?
    
    var articleUplodSingleImage: ArticleUplodSingleImage?

    
    func loadArticlesWithData(search:String, page:Int, limit:Int) {
        
        print("Download Started...\(search)")
        
        
        let url = URL(string: "\(Constant.ArticleManagment.BASE_URL)?title=\(search)&page=\(page)&limit=\(limit)")
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.addValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in

            if error == nil {
                
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject] {
                    
                    let jsonDATA = json["DATA"] as! [AnyObject]
                    
                    for data in jsonDATA {
                        
                        self.articles.append(Article(JSON: data as! [String: Any])!)
                    }
                    
                    //====== Notify Respose Data Function ============
                    self.delegate?.responseWithArticle(articles: self.articles)
                }
                
            }
            
        })
        
        task.resume()
        
    }
    
    //================ upload data to server ==================
    
    func sendArticleToServer(article: Article) {
        
        
        do {
            
//            let jsonData = try JSONSerialization.data(withJSONObject: article, options:.prettyPrinted)
            
           let jsonString = article.toJSONString()
            print("jsong ========= \(jsonString)")
            //print("sending data \(jsonData)")
            // create post request
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
    //============= upload image to data
    func uploadImage(data: Data) {
        
        
        let url = URL(string: Constant.ArticleManagment.BASE_URL_SINGLE_IMAGE)
        var request = URLRequest(url: url!)
        
        
        // Set method
        request.httpMethod = "POST"
        
        
        // Set boundary
       request.setValue(Constant.AuthConstant.headers_article["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create requestBody
        var formData = Data()
        
//        let imageData = UIImagePNGRepresentation(data!)
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
                    
                }catch let error{
                    print("Error : \(error.localizedDescription)")
                }
                
                self.articleUplodSingleImage?.uploadSingleImageFromServiceComplete(imageURL: jsonData!)
                
            }else{
            
                print("\(error?.localizedDescription)")
            }
            
        }
        
        uploadTask.resume()
        
    }
    
}
