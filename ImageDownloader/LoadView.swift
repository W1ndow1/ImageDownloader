//
//  LoadView.swift
//  ImageDownloader
//
//  Created by window1 on 2023/03/13.
//

import UIKit

class LoadView: UIView, URLSessionTaskDelegate {
    
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
    private var imageLoadTask: Task<Void, Error>!
    
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
    
    func fetchImage(url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        if imageLoadTask.isCancelled { return UIImage(systemName: "photo")! }
        let (data, response) = try await URLSession.shared.data(for: request, delegate: self)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else { throw NSError(domain: "fetchError", code: 1004) }
        if imageLoadTask.isCancelled { return UIImage(systemName: "photo")! }
        guard let image = UIImage(data: data) else { throw NSError(domain: "image converting error", code: 999)}
        return image
    }
    
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        observation = task.progress.observe(\.fractionCompleted, options: [.new], changeHandler: { progress, value in
            DispatchQueue.main.async {
                self.progressView.progress = Float(progress.fractionCompleted)
            }
        })
    }
    
    func startLoad(url: URL) {
        imageLoadTask = Task(priority: .high) {
            let image = try await fetchImage(url: url)
            imageView.image = image
        }
    }
    
    
    @IBAction private func touchLoadImageButton(_ sender: UIButton) {
        imageView.image = .init(systemName: "photo")
        sender.isSelected = !sender.isSelected
        
        guard sender.isSelected else {
            imageLoadTask.cancel()
            return
        }
        
        guard (0...4).contains(sender.tag) else {
            fatalError("Checking Button Tag")
        }
        let url = ImageURL[sender.tag]
        startLoad(url: url)

    }
}
