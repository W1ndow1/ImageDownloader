//
//  LoadView.swift
//  ImageDownloader
//
//  Created by window1 on 2023/03/13.
//

import UIKit

class LoadView: UIView {
    
    struct ImageURL {
       static let imageIds: [String] = [
            "europe-4k-1369012",
            "europe-4k-1318341",
            "europe-4k-1379801",
            "cool-lion-167408",
            "iron-man-323408"
        ]
        
        static subscript(index: Int) -> URL {
            let id = imageIds[index]
            return URL(string: "https://wallpaperaccess.com/download/"+id)!
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var loadButton: UIButton!
    private var task: URLSessionDataTask!
    private var observation: NSKeyValueObservation!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadButton.setTitle("Stop", for: .selected)
        loadButton.setTitle("Load", for: .normal)
        loadButton.isSelected = false
    }
    
    deinit {
        observation.invalidate()
        observation = nil
    }
    
    func reset() {
        imageView.image = .init(systemName: "photo")
        progressView.progress = 0
        loadButton.isSelected = false
    }
    
    func loadImage() {
        loadButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction private func touchLoadImageButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard sender.isSelected else {
            task.cancel()
            return
        }
        
        guard (0...4).contains(sender.tag) else {
            fatalError("Checking Button Tag")
        }
        let url = ImageURL[sender.tag]
        let request = URLRequest(url: url)
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error =  error {
                guard error.localizedDescription == "cancelled" else {
                    fatalError(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.reset()
                }
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "xmark")
                }
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.loadButton.isSelected = false
            }
        }
        task.resume()
        observation = task.progress.observe(\.fractionCompleted, options: [.new], changeHandler: { progress, change in
            
            DispatchQueue.main.async {
                self.progressView.progress = Float(progress.fractionCompleted)
            }
        })
        task.resume()
    }
}
