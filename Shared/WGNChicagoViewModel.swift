//
//  WGNChicagoViewModel.swift
//  WGN Chicago
//
//  Created by Nick Thompson on 11/28/21.
//

import AVKit
import Combine
import JavaScriptCore

@MainActor
class WGNChicagoViewModel: ObservableObject {
    enum ViewState: Equatable {
        case loading
        case playing(URL)
        case error(WGNError)
    }

    enum WGNError: Error, Equatable, LocalizedError {
        case networkError(reason: String)
        case decodingError
        case extractionError

        var errorDescription: String? {
            switch self {
            case .networkError:
                return "A network error occured while fetching the stream."
            case .decodingError:
                return "An error occured decoding the stream."
            case .extractionError:
                return "An error occured extracting the stream."
            }
        }

        var failureReason: String? {
            switch self {
            case .networkError(let reason):
                return reason
            case .decodingError, .extractionError:
                return nil
            }
        }
    }

    @Published private(set) var state: ViewState = .loading
    private let session = URLSession.shared
    private var loadingTask: Task<Void, Never>?

    func load() {
        guard loadingTask == nil else {
            return
        }
        state = .loading
        loadingTask = Task {
            switch await getMasterUrl() {
            case .success(let url):
                state = .playing(url)
            case .failure(let error):
                state = .error(error)
            }
            loadingTask = nil
        }
    }

    func getMasterUrl() async -> Result<URL, WGNError> {
        let url = URL(string: "https://tkx.mp.lura.live/rest/v2/mcp/video/adstJjQDmxajd3nl?anvack=vLroBA9ZBG3JwTvaOlibbtoPb6L4jqJl")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let data: Data
        do {
            (data, _) = try await session.data(for: request)
        } catch {
            return .failure(.networkError(reason: error.localizedDescription))
        }
        guard let payload = String(data: data, encoding: .utf8) else {
            return .failure(.decodingError)
        }
        guard let masterUrlString = anvatoContext?.evaluateScript(payload).toString(),
              let masterUrl = URL(string: masterUrlString)
        else {
            return .failure(.extractionError)
        }
        return .success(masterUrl)
    }


    private var anvatoContext: JSContext? {
        let context = JSContext()
        context?.evaluateScript(#"""
            function anvatoVideoJSONLoaded(payload) {
                return payload.published_urls[0].embed_url
            }
            """#)
        return context
    }
}
