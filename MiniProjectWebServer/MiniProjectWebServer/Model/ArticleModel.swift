//
//  ArticleModel.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/11/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    
    var id: String?
    var title: String?
    var description: String?
    var created_date: String?
    var author: Author?
    var status: String?
    var image: String?
    var pagination: Pagination?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id              <- map["ID"]
        title           <- map["TITLE"]
        description     <- map["DESCRIPTION"]
        created_date    <- map["CREATED_DATE"]
        author          <- map["AUTHOR"]
        status          <- map["STATUS"]
        image           <- map["IMAGE"]
        pagination      <- map["PAGINATION"]
    }
    
}

class Pagination: Mappable {
    
    var page: String?
    var limit: Int?
    var total_count: Int?
    var total_pages: Int?
    
    required init?(map: Map) {}
    
    // Mappable Object
    func mapping(map: Map) {
        page            <- map["PAGE"]
        limit           <- map["LIMIT"]
        total_count     <- map["TOTAL_COUNT"]
        total_pages     <- map["TOTAL_COUNT"]
      
    }
}

class Category: Mappable {
    
    var id: Int?
    var name: String?
    
    required init?(map: Map) {}
    
    // Mappable Object
    func mapping(map: Map) {
        id       <- map["ID"]
        name     <- map["NAME"]
        
    }
}

class Author: Mappable {
    
    var id: Int?
    var name: String?
    var email: String?
    var gender: String?
    var telephone: String?
    var status: String?
    var facebook_id: String?
    var image_url: String?
    
    required init?(map: Map) {}
    
    // Mappable Object
    func mapping(map: Map) {
        id              <- map["ID"]
        name            <- map["NAME"]
        email           <- map["EMAIL"]
        gender          <- map["GENDER"]
        telephone       <- map["TELEPHONE"]
        status          <- map["STATUS"]
        facebook_id     <- map["FACEBOOK_ID"]
        image_url       <- map["IMAGE_URL"]
        
    }
}


