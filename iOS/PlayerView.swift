//
//  PlayerView.swift
//  WGN Chicago
//
//  Created by Nick Thompson on 11/28/21.
//

import AVKit
import SwiftUI

struct PlayerView: UIViewControllerRepresentable {
    @Binding var url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = true
        playerViewController.exitsFullScreenWhenPlaybackEnds = true
        playerViewController.modalPresentationStyle = .fullScreen
        playerViewController.updatesNowPlayingInfoCenter = true
        playerViewController.view.backgroundColor = .clear
        playerViewController.player = player
        player.play()
        return playerViewController
    }

    func updateUIViewController(_ playerViewController: AVPlayerViewController, context: Context) {

    }
}
