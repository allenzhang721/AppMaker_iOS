//
//  DemoBooks.swift
//  Smart App Creator
//
//  Created by Emiaostein on 14/05/2017.
//  Copyright © 2017 botai. All rights reserved.
//

import Foundation

extension BookModel {
    class var demoBooks: [BookModel] {
        
        let books: [BookModel] =
            []
//                ["curlFlip","tableView", "book"]
//                ["book","book2"]
//                ["countbook", "timebook", "tablebook"]
                .map{let model = BookModel(IP: ""); model.name = $0 as! String; model.isDemo = true; return  model}
        
        return books
    }
}
