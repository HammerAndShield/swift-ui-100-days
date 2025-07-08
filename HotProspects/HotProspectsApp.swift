//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by austin townsend on 7/5/25.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
