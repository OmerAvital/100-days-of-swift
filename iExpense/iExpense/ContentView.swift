//
//  ContentView.swift
//  iExpense
//
//  Created by Omer Avital on 6/2/22.
//

import SwiftUI

struct ExpenseRow: View {
    let item: ExpenseItem
    let currencyCode = Locale.current.currencyCode ?? "USD"
    
    var body: some View {
        HStack {
            Text(item.name)
                .font(.headline)
            
            Spacer()
            
            Text(item.amount, format: .currency(code: currencyCode))
                .foregroundColor(item.amount > 100 ? .purple : (item.amount > 10 ? .pink : nil))
        }
        .accessibilityElement()
        .accessibilityLabel("\(item.name), \(item.amount, format: .currency(code: currencyCode))")
        .accessibilityHint(item.type)
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var expensesByType: [[ExpenseItem]] {
        var ebt = [[ExpenseItem]]()
        
        for expense in expenses.items {
            if let typeIndex = ebt.firstIndex(where: { $0.first?.type == expense.type }) {
                ebt[typeIndex].append(expense)
            } else {
                ebt.append([expense])
            }
        }
        
        return ebt
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expensesByType, id: \.first?.type) { sortedExpenses in
                    Section(sortedExpenses.first?.type ?? "") {
                        ForEach(sortedExpenses) { expense in
                            ExpenseRow(item: expense)
                        }
                        .onDelete { offsets in
                            guard let type = sortedExpenses.first?.type else { return }
                            
                            removeItems(at: offsets, forType: type)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, forType type: String) {
        guard let expensesOfTypeIndex = expensesByType.firstIndex(where: { $0.first?.type == type }) else {
            return
        }
        
        var expensesOfType = expensesByType[expensesOfTypeIndex]
        expensesOfType.remove(atOffsets: offsets)
        
        var toRemove = expensesByType[expensesOfTypeIndex]
        toRemove.removeAll(where: { expensesOfType.firstIndex(of: $0) != nil })
        
        expenses.items.removeAll(where: { toRemove.firstIndex(of: $0) != nil })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
