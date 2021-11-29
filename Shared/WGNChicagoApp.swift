//
//  WGNChicagoApp.swift
//  WGN Chicago
//
//  Created by Nick Thompson on 11/28/21.
//

import AVKit
import SwiftUI

@main
struct WGNChicagoApp: App {
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }

    var body: some Scene {
        WindowGroup {
            WGNChicagoView()
        }
    }
}
