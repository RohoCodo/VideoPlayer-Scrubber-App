//
//  ContentView.swift
//  Shared
//
//  Created by Rohan Tyagi on 4/16/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var player = AVPlayer()
    @StateObject private var playerVM = PlayerViewModel()
    
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    let videoURL: URL = Bundle.main.url(forResource: "IMG_0223", withExtension: "MOV")!
    
    init() {
            // we need this to use Picture in Picture
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
//    NSBundle.mainBundle().URLForResource("Para1_2", withExtension: "mp4")!
    
    var body: some View {
        ZStack{
            //video player without any controls
//            VStack{
//            VideoPlayer(player: player)
            VStack{
                CustomVideoPlayer(playerVM: playerVM)
                
                if  (CMTimeGetSeconds(playerVM.player.currentTime())/60).rounded(.down).isNaN != true && (CMTimeGetSeconds(playerVM.player.currentTime())/60).rounded(.down).isInfinite != true {
                    if (CMTimeGetSeconds(playerVM.player.currentTime()).truncatingRemainder(dividingBy: 60).rounded(.down)).isNaN != true && (CMTimeGetSeconds(playerVM.player.currentTime()).truncatingRemainder(dividingBy: 60).rounded(.down)).isInfinite != true{
                        if((Int(CMTimeGetSeconds(playerVM.player.currentTime()).truncatingRemainder(dividingBy: 60).rounded(.down))) < 10){
                            Text("\(Int((CMTimeGetSeconds(playerVM.player.currentTime())/60).rounded(.down))):0\(Int(CMTimeGetSeconds(playerVM.player.currentTime()).truncatingRemainder(dividingBy: 60).rounded(.down)))")
                        }
                        else{
                            Text("\(Int((CMTimeGetSeconds(playerVM.player.currentTime())/60).rounded(.down))):\(Int(CMTimeGetSeconds(playerVM.player.currentTime()).truncatingRemainder(dividingBy: 60).rounded(.down)))")
                        }
                    }
                }
                
                Thumbnail(video: videoURL, pm: playerVM)
                    .overlay(Scrubber())
                
                HStack {
                    if playerVM.isPlaying == false {
                        Button(action: {
                            playerVM.player.play()
                        }, label: {
                            Image(systemName: "play.circle")
                                .imageScale(.large)
                        })
                    } else {
                        Button(action: {
                            playerVM.player.pause()
                        }, label: {
                            Image(systemName: "pause.circle")
                                .imageScale(.large)
                        })
                    }
                }
                
                
            }
            
    //                Spacer().frame(width: UIScreen.main.bounds.width/2)
    //                    .frame(width: UIScreen.main.bounds.width/2)
//            }
//            Spacer().frame(height: 100)
            
            //overlay scrubber - connect with video time
            //play pause button here
            
        }
        .onAppear(){
            playerVM.setCurrentItem(AVPlayerItem(url: videoURL))
//            player.currentItem?.asset = AVURLAsset(url: videoURL)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
