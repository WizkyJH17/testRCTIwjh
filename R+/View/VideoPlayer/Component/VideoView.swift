//
//  VideoView.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import UIKit
import AVKit

// MARK: - Component View
class VideoView: UIView {
    // Variable
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var isPlay: Bool = true

    // Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

// MARK: - Init Function
extension VideoView {
    private func setupView() {
        setupPlayerLayer()
    }
    
    private func setupPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
    }
}

// MARK: - Component Setup
extension VideoView {
    func configure(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer?.player = player
        player?.play()
    }
}

// MARK: - Vide Control Function
extension VideoView {
    func pause() {
        player?.pause()
    }
    
    func play() {
        player?.play()
    }
}
