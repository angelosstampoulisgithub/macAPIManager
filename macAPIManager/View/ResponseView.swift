//
//  ResponseView.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import SwiftUI

struct ResponseView: View {
    let response: HTTPResponseModel?
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection

            Divider()

            if let errorMessage {
                errorView(errorMessage)
            } else if let response {
                contentView(response)
            } else {
                placeholderView
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Text("Response")
                .font(.headline)

            Spacer()

            if let response {
                Text("Status: \(response.statusCode)")
                    .foregroundStyle(statusColor(response.statusCode))

                Text(String(format: "Time: %.2f ms", response.duration * 1000))
                    .foregroundStyle(.secondary)

                Text("Size: \(ByteCountFormatter.string(fromByteCount: Int64(response.body.count), countStyle: .file))")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    // MARK: - Content

    private func contentView(_ response: HTTPResponseModel) -> some View {
        TabView {
            prettyBodyView(response)
                .tabItem { Text("Body") }

            rawBodyView(response)
                .tabItem { Text("Raw") }

            headersView(response)
                .tabItem { Text("Headers") }
        }
        .tabViewStyle(.automatic)
    }

    // MARK: - Body (Pretty)

    private func prettyBodyView(_ response: HTTPResponseModel) -> some View {
        ScrollView {
            Text(prettyPrintedJSON(from: response.body) ?? "No preview available")
                .font(.system(.body, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    // MARK: - Body (Raw)

    private func rawBodyView(_ response: HTTPResponseModel) -> some View {
        ScrollView {
            Text(String(decoding: response.body, as: UTF8.self))
                .font(.system(.body, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    // MARK: - Headers

    private func headersView(_ response: HTTPResponseModel) -> some View {
        List(response.headers) { header in
            HStack {
                Text(header.name)
                    .fontWeight(.medium)
                Spacer()
                Text(header.value)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack {
            Text("Error")
                .font(.title3)
                .padding(.bottom, 4)

            Text(message)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Placeholder

    private var placeholderView: some View {
        VStack {
            Text("No response yet")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private func prettyPrintedJSON(from data: Data) -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: data),
            let pretty = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let string = String(data: pretty, encoding: .utf8)
        else {
            return nil
        }
        return string
    }

    private func statusColor(_ code: Int) -> Color {
        switch code {
        case 200..<300: return .green
        case 300..<400: return .blue
        case 400..<600: return .red
        default: return .secondary
        }
    }
}
