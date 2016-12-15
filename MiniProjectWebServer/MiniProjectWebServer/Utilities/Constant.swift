//
//  Constant.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/11/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import Foundation

class Constant {

    struct AuthConstant {
        
        static var headers_article = [
            
            "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
            "Accept": "application/json; charset=utf-8"
        ]
        
        static let headers_multi_upload = [
            
            "Authorization": "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
            "Accept": "application/json; charset=utf-8"
        ]
    }
    
    struct ArticleManagment {
        
        static let BASE_URL = "http://120.136.24.174:1301/v1/api/articles"
        static let BASE_URL_SINGLE_IMAGE = "http://120.136.24.174:1301/v1/api/uploadfile/single"
        
    }
    
    
}
