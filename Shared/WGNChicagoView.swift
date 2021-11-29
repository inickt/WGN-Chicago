//
//  WGNChicagoView.swift
//  WGN Chicago
//
//  Created by Nick Thompson on 11/28/21.
//

import AVKit
import SwiftUI

struct WGNChicagoView: View {
    @StateObject private var viewModel = WGNChicagoViewModel()

    var body: some View {
        NavigationView {
            content
                .onAppear {
                    viewModel.load()
                }
                .navigationTitle("WGN Chicago")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.load()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        RoutePickerView()
                    }
                }
        }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading...")
        case .error(let error):
            VStack {
                if let description = error.errorDescription {
                    Text(description).font(.title3)
                }
                if let reason = error.failureReason {
                    Text(reason)
                }
                Button("Retry") {
                    viewModel.load()
                }.buttonStyle(BorderedButtonStyle())
            }.multilineTextAlignment(.center)
        case .playing(let url):
            PlayerView(url: .constant(url))
        }
    }
}
