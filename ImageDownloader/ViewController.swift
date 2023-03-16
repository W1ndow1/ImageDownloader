//
//  ViewController.swift
//  ImageDownloader
//
//  Created by window1 on 2023/02/24.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    

    @IBOutlet private var views: [LoadView]!
    
    var arrImageView: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views.forEach { $0.reset() }
        
    }
    @IBAction func touchUpLoadAllImageButton(_ sender: UIButton) {
        views.forEach { $0.loadImage() }
    }
}

