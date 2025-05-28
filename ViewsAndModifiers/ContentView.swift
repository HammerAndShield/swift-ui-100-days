//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by austin townsend on 5/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            GridStack(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
             ForEach(0..<rows, id: \.self) { row in
                 HStack {
                     ForEach(0..<columns, id: \.self) { column in
                         content(row, column)
                     }
                 }
             }
         }
    }
}


#Preview {
    ContentView()
}
