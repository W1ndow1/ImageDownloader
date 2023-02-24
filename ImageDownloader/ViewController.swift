//
//  ViewController.swift
//  ImageDownloader
//
//  Created by window1 on 2023/02/24.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    
    var arrImageView: [UIImageView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let arrImageView: [UIImageView] = [imageView1, imageView2, imageView3, imageView4, imageView5]
        let arrPictureId: [Int] = [0, 31, 52, 10, 25]
        var imageViews: [UIImageView] = []
        var pictureId: [Int] = []
        
        switch sender.tag {
        case 0:
            imageViews.append(arrImageView[0])
            pictureId.append(0)
        case 1:
            imageViews.append(arrImageView[1])
            pictureId.append(31)
        case 2:
            imageViews.append(arrImageView[2])
            pictureId.append(52)
        case 3:
            imageViews.append(arrImageView[3])
            pictureId.append(10)
        case 4:
            imageViews.append(arrImageView[4])
            pictureId.append(25)
        default:
            imageViews = arrImageView
            pictureId = arrPictureId
        }
        Task {
              try await allloadIamge(id: pictureId, view: imageViews)
        }
    }

    public func allloadIamge(id pictureId: [Int], view imageViews: [UIImageView]) async throws -> Void {
        let imageViewId = [0, 1, 2, 3, 4]
        let placeholderImage = UIImage(systemName: "square.and.arrow.down")
        imageViews.forEach({ $0.image = placeholderImage })
        for id in pictureId.count > 1 ? imageViewId : pictureId {
            guard let url = URL(string: "https://picsum.photos/id/\(pictureId[pictureId.count > 1 ? id : 0])/200/300") else {
                throw NetworkError.badURL
            }
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.invalidResponse }
            guard let image = UIImage(data: data) else { throw NetworkError.invalidData }
            imageViews[pictureId.count > 1 ? id : 0].image = image
        }
    }
}

