//
//  Thumbnail.swift
//  VideoPlayerApp
//
//  Created by Rohan Tyagi on 4/17/22.
//

import Foundation
import SwiftUI
import AVKit

struct Thumbnail: View {
    //give the photos here
    @State var video: URL
    @State var cgImages: [CGImage] = []
    @State var pm : PlayerViewModel
    @State private var scrollViewContentOffset = CGFloat(0)
    @GestureState var location = CGPoint(x: 0, y: 0)
    @State var seconds: Int = 0
    
    

//need data on what part of thumbnail is in center of view
    var body: some View {
        ZStack{

            TrackableScrollView(.horizontal, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                    HStack(spacing: 0){
                        
                        ForEach(self.cgImages, id: \.self){ im in
                            ThumbnailCard(im: im)

                        }
                    }
                    
//                    .onTapGesture {
//                        print(5 * scrollViewContentOffset/(UIScreen.main.bounds.width/5))
//                        pm.player.seek(to: CMTime(seconds: (5 * scrollViewContentOffset/(UIScreen.main.bounds.width/5)), preferredTimescale: CMTimeScale(1)))
//                        pm.currentTime = 5 * scrollViewContentOffset/(UIScreen.main.bounds.width/5)
//                    }
            }.gesture(DragGesture().updating($location, body: { val, gstate, transact in
                gstate = val.location
//                print(5 * scrollViewContentOffset/(UIScreen.main.bounds.width/5))
                pm.player.seek(to: CMTime(seconds: (5 * scrollViewContentOffset/(UIScreen.main.bounds.width/5)), preferredTimescale: CMTimeScale(1)))
            }))
            
            
//            .onDrag {
//                pm.player.seek(to: CMTime(seconds: (5 * scrollViewContentOffset/(UIScreen.main.bounds.width/5)), preferredTimescale: CMTimeScale(1)))
//            }
//            ScrollViewReader{ scrollView in
//                ScrollView(.horizontal, showsIndicators: false){
//    //                GeometryReader { g in
//                    HStack(spacing: 0){
//                        ForEach(self.cgImages, id: \.self){ im in
//                            ThumbnailCard(im: im)
//
//                        }
//                    }
//                    .onTapGesture {
////                        pm.player.curr
//                    }
//    //                }
//                }.frame(height: 150)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//            }
                
//                .alignmentGuide(.center)
//            .frame(width: UIScreen.main.bounds.width/3, height: 50, alignment: .center)
        }
        .onAppear(){
            //create
//            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Time"), object: ob, queue: .main) { notification in [self]
////            set seconds to the
//                self.seconds = notification.object as! Int
//            }
            
            let asset = AVURLAsset(url: video)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let numThumbs = asset.duration.seconds
            var each = 0.0
            while(each <= numThumbs){
                print(each)
                do {
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: Int64(each), timescale: 1), actualTime: nil)
                    cgImages.append(cgImage)
                }
                catch {
                    return;
                }
                each += 5
            }
            
        }
    }

}

struct ThumbnailCard: View {
//    var restaurant: RestaurantFB
//    var HomeScreenVM : HomeScreenViewModel
//    var location: Double
    var im : CGImage
    
    var body: some View {
            VStack {
                HStack {
                    Image(uiImage:  UIImage(cgImage: im))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/5, height: 60)
                        
                }
            }

        }
}
