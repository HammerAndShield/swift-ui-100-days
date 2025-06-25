//
//  BookwormApp.swift
//  Bookworm
//
//  Created by austin townsend on 6/11/25.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
