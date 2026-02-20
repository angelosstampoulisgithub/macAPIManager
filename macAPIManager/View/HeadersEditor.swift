//
//  HeadersEditor.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import SwiftUI

struct HeadersEditor: View {
    @Binding var headers: [HTTPHeader]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Headers")
                    .font(.headline)
                Spacer()
                Button {
                    addHeader()
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
            .padding(.bottom, 4)

            Table(headers) {
                TableColumn("Name") { header in
                    TextField("Header", text: binding(for: header).name)
                        .textFieldStyle(.plain)
                }
                TableColumn("Value") { header in
                    TextField("Value", text: binding(for: header).value)
                        .textFieldStyle(.plain)
                }
                TableColumn("") { header in
                    Button {
                        remove(header)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                }
                .width(30)
            }
        }
        .padding()
    }

    // MARK: - Helpers

    private func binding(for header: HTTPHeader) -> Binding<HTTPHeader> {
        guard let index = headers.firstIndex(where: { $0.id == header.id }) else {
            fatalError("Header not found")
        }
        return $headers[index]
    }

    private func addHeader() {
        headers.append(HTTPHeader(name: "", value: ""))
    }

    private func remove(_ header: HTTPHeader) {
        headers.removeAll { $0.id == header.id }
    }
}
