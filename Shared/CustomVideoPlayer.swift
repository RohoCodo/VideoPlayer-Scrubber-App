//
//  CustomVideoPlayer.swift
//  VideoPlayerApp
//
//  Created by Rohan Tyagi on 4/17/22.
//

import AVKit
import SwiftUI
import Combine

class PlayerView: UIView {

    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

struct CustomVideoPlayer: UIViewRepresentable {
    
    @ObservedObject var playerVM: PlayerViewModel
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
     class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: CustomVideoPlayer
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?
        
        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
            super.init()
            
            cancellable = parent.playerVM.$isInPipMode
                .sink { [weak self] in
                    guard let self = self,
                          let controller = self.controller else { return }
                    if $0 {
                        if controller.isPictureInPictureActive == false {
                            controller.startPictureInPicture()
                        }
                    } else if controller.isPictureInPictureActive {
                        controller.stopPictureInPicture()
                    }
                }
        }
        
        func setController(_ playerLayer: AVPlayerLayer) {
            controller = AVPictureInPictureController(playerLayer: playerLayer)
            controller?.canStartPictureInPictureAutomaticallyFromInline = true
            controller?.delegate = self
        }
        
        func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = true
        }
        
        func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = false
        }
    }
}
