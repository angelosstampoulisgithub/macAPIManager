//
//  ContentView.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: RequestEditorViewModel

    var body: some View {
        VStack {
            HStack {
                Picker("Method", selection: $viewModel.request.method) {
                    ForEach(HTTPMethod.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .frame(width: 190)

                TextField("https://api.example.com/path", text: $viewModel.request.url)
                    .textFieldStyle(.roundedBorder)

                Button(viewModel.isSending ? "Cancel" : "Send") {
                    if viewModel.isSending {
                        viewModel.cancel()
                    } else {
                        viewModel.send()
                    }
                }
                .keyboardShortcut(.return, modifiers: [.command])
            }

            // Headers + Body editor (split view)
            HSplitView {
                HeadersEditor(headers: $viewModel.request.headers)
                BodyEditor(httpBody: $viewModel.request.body)
            }
            .frame(minHeight: 200)

            Divider()

            ResponseView(response: viewModel.response, errorMessage: viewModel.errorMessage)
                .frame(minHeight: 200)
        }
        .padding()
    }
}


