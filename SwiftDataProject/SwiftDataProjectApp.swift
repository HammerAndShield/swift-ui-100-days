//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by austin townsend on 6/25/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
