//
//  ViewController.swift
//  TikTokFeed
//
//  Created by HieuTong on 6/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var data = [VideoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for _ in 0..<10 {
            let model = VideoModel(caption: "This is a cool video", username: "@afraz", audioTrackName: "iOS Academy Video song", videoFileName: "video", videoFileFormat: "mp4")
            data.append(model)
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        collectionView?.delegate = self
        if let col = collectionView {
            view.addSubview(col)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        cell.delegate = self
        cell.configure(model: model)
        return cell
    }
}

extension ViewController: VideoCollectionViewCellDelegate {
    func didTapLikeButton(with model: VideoModel) {
        print("like")
    }
    
    func didTapProfileButton(with model: VideoModel) {
        print("profile")
    }
    
    func didTapShareButton(with model: VideoModel) {
        print("share")
    }
    
    func didTapCommentButton(with model: VideoModel) {
        print("comment")
    }
}

