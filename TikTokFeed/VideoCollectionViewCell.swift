//
//  File.swift
//  TikTokFeed
//
//  Created by HieuTong on 6/5/21.
//

import UIKit
import AVFoundation

protocol VideoCollectionViewCellDelegate: NSObjectProtocol {
    func didTapLikeButton(with model: VideoModel)
    
    func didTapProfileButton(with model: VideoModel)
    
    func didTapShareButton(with model: VideoModel)
    
    func didTapCommentButton(with model: VideoModel)
}

struct VideoModel {
    let caption: String
    let username: String
    let audioTrackName: String
    let videoFileName: String
    let videoFileFormat: String
}

class VideoCollectionViewCell: UICollectionViewCell {
    static let identifier = "VideoCollectionViewCell"
    
    //labels
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let audioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    //buttons
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        return button
    }()
    
    private let videoContainer = UIView()
    
    //delegates
    weak var delegate: VideoCollectionViewCellDelegate?
    //subviews
    var player: AVPlayer?
    private var model: VideoModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
        contentView.clipsToBounds = true
        addSubviews()
    }
    
    private func addSubviews() {
        contentView.addSubview(videoContainer)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(audioLabel)

        contentView.addSubview(profileButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        //add actions
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchDown)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchDown)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchDown)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchDown)

        videoContainer.clipsToBounds = true
        contentView.sendSubviewToBack(videoContainer)
    }
    
    @objc func didTapProfileButton() {
        guard let model = model else { return }
        delegate?.didTapProfileButton(with: model)
    }
    
    @objc func didTapLikeButton() {
        guard let model = model else { return }
        delegate?.didTapLikeButton(with: model)
    }
    
    @objc func didTapCommentButton() {
        guard let model = model else { return }
        delegate?.didTapCommentButton(with: model)
    }
    
    @objc func didTapShareButton() {
        guard let model = model else { return }
        delegate?.didTapShareButton(with: model)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoContainer.frame = contentView.bounds
        
        let size = contentView.frame.size.width / 7
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 100
        
        //button
        shareButton.frame = CGRect(x: width - size, y: height - size, width: size, height: size)
        commentButton.frame = CGRect(x: width - size, y: height - (size*2) - 10, width: size, height: size)
        likeButton.frame = CGRect(x: width - size, y: height - (size*3) - 10, width: size, height: size)
        profileButton.frame = CGRect(x: width - size, y: height - (size*4) - 10, width: size, height: size)
        
        //labels
        audioLabel.frame = CGRect(x: 5, y: height - 50, width: width - size - 10, height: 50)
        captionLabel.frame = CGRect(x: 5, y: height - 80, width: width - size - 10, height: 50)
        usernameLabel.frame = CGRect(x: 5, y: height - 110, width: width - size - 10, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        captionLabel.text = nil
        audioLabel.text = nil
        usernameLabel.text = nil
    }
    
    public func configure(model: VideoModel) {
        //configure
        self.model = model
        configureVideo()
        
        //labels
        captionLabel.text = model.caption
        audioLabel.text = model.audioTrackName
        usernameLabel.text = model.username
    }
    
    private func configureVideo() {
        guard let model = model else { return }
        guard let path = Bundle.main.path(forResource: model.videoFileName, ofType: model.videoFileFormat) else {
            print("failed")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        player = AVPlayer(url: url)
        
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
    }
}
