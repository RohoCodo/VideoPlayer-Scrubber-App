//
//  Scrubber.swift
//  VideoPlayerApp
//
//  Created by Rohan Tyagi on 4/17/22.
//

import Foundation
import SwiftUI

struct Scrubber: View {
    @State var time = 0.0
    
    var body: some View {
        ZStack{
            VStack{
                Spacer().frame(height: 100)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red)
                    .frame(width: 10, height: 60)
            }
        }
    }
    
    
}
