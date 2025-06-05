//
//  ContentView.swift
//  iExpense
//
//  Created by austin townsend on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false

    func removeItems(at offsets: IndexSet, from section: String) {
        let itemsToRemove = section == "Personal" ? offsets.map { expenses.personal[$0].id } : offsets.map { expenses.business[$0].id }
        

        expenses.items.removeAll { itemsToRemove.contains($0.id) }
    }

    private func color(for amount: Double) -> Color {
        switch amount {
        case ..<10:
            .green
        case ..<100:
            .orange
        default:
            .red
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.personal) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(
                                item.amount,
                                format: .currency(code: expenses.currencyCode)
                            )
                            .foregroundStyle(color(for: item.amount))
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: "Personal")
                    }
                }
                
                Section("Business") {
                    ForEach(expenses.business) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(
                                item.amount,
                                format: .currency(code: expenses.currencyCode)
                            )
                            .foregroundStyle(color(for: item.amount))
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: "Business")
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
}

#Preview {
    ContentView()
}
