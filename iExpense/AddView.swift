//
//  SwiftUIView.swift
//  iExpense
//
//  Created by austin townsend on 6/4/25.
//

import SwiftUI

struct AddView: View {
    @State private var name = "Expense Name"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: expenses.currencyCode))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        expenses.items.append(item)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
