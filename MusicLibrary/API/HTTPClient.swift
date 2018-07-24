//
//  HTTPClient.swift
//  MusicLibrary
//
//  Created by Afiq Ramli on 20/07/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import Foundation
import UIKit

class HTTPClient {
    
    func getRequest(_ url: String) -> (AnyObject) {
        return Data() as (AnyObject)
    }
    
    func postRequest(_ url: String, body: String) -> (AnyObject){
        return Data() as (AnyObject)
    }
    
    // This is synchronous way to download image via url, please use it in background
    
    func downloadImage(_ url: String) -> (UIImage) {
        let aUrl = URL(string: url)
        
        guard let data = try? Data(contentsOf: aUrl!) else {
            return UIImage()
        }
        
        let image = UIImage(data: data)
        return image!
    }
    
}
