//
//  ViewController.swift
//  SACPublisher
//
//  Created by Emiaostein on 21/02/2017.
//  Copyright © 2017 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    private func setup() {
        let bookDir = Bundle.main.bundleURL.appendingPathComponent("book", isDirectory: true)
        appMaker.openBook(withRootViewController: self, bookDirectoryPath: bookDir.path, theDelegate: nil, hiddenBackIcon: true, hiddenShareIcon: true)
    }
}

