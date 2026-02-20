//
//  RequestEditorViewModel.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import Foundation
@MainActor
final class RequestEditorViewModel: ObservableObject {
    @Published var request = HTTPRequest()
    @Published var response: HTTPResponseModel?
    @Published var isSending = false
    @Published var errorMessage: String?

    private let client: HTTPClient
    private var task: Task<Void, Never>?

    init(client: HTTPClient) {
        self.client = client
    }

    func send() {
        errorMessage = nil
        response = nil
        isSending = true

        task?.cancel()
        task = Task {
            do {
                let result = try await client.send(request)
                await MainActor.run {
                    self.response = result
                    self.isSending = false
                }
            } catch is CancellationError {
                await MainActor.run {
                    self.isSending = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isSending = false
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
