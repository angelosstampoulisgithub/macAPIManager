//
//  macAPIManagerApp.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import SwiftUI

@main
struct macAPIManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(client: URLSessionHTTPClient()))
                .frame(width:900,height:695)
        }.windowResizability(.contentSize)
    }
}
