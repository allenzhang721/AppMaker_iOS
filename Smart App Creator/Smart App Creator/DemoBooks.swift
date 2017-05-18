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
//                ["curlFlip","tableView", "book"]
                ["linebook"]
                .map{let model = BookModel(IP: ""); model.name = $0; model.isDemo = true; return  model}
        
        return books
    }
}
