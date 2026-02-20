//
//  BodyEditor.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import SwiftUI

struct BodyEditor: View {
    @Binding var httpBody: HTTPBody

    @State private var rawText: String = ""
    @State private var contentType: String = "application/json"
    @State private var prettyPrinted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Body")
                    .font(.headline)

                Spacer()

                Picker("", selection: bindingForBodyType) {
                    Text("None").tag(BodyType.none)
                    Text("Raw").tag(BodyType.raw)
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
            }

            if bindingForBodyType.wrappedValue == .raw {
                HStack {
                    Picker("Content‑Type", selection: $contentType) {
                        Text("JSON").tag("application/json")
                        Text("Text").tag("text/plain")
                        Text("Custom…").tag("custom")
                    }
                    .frame(width: 180)

                    if contentType == "custom" {
                        TextField("Custom MIME type", text: $contentType)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }

                    Spacer()

                    Toggle("Pretty JSON", isOn: $prettyPrinted)
                        .onChange(of: prettyPrinted) { _ in
                            prettyPrintJSON()
                        }
                }

                TextEditor(text: $rawText)
                    .font(.system(.body, design: .monospaced))
                    .padding(4)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(6)
                    .onChange(of: rawText) { _ in
                        syncToModel()
                    }
                    .onAppear {
                        loadFromModel()
                    }
            }
        }
        .padding()
    }

    // MARK: - BodyType

    private enum BodyType {
        case none
        case raw
    }

    private var bindingForBodyType: Binding<BodyType> {
        Binding {
            switch httpBody {
            case .none: return .none
            case .raw: return .raw
            }
        } set: { newValue in
            switch newValue {
            case .none:
                httpBody = .none
            case .raw:
                httpBody = .raw(rawText, contentType: contentType)
            }
        }
    }

    // MARK: - Sync

    private func loadFromModel() {
        if case let .raw(text, type) = httpBody {
            rawText = text
            contentType = type
        }
    }

    private func syncToModel() {
        httpBody = .raw(rawText, contentType: contentType)
    }

    private func prettyPrintJSON() {
        guard prettyPrinted else { return }
        guard contentType == "application/json" else { return }

        if let data = rawText.data(using: .utf8),
           let object = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            rawText = prettyString
            syncToModel()
        }
    }
}
