import SwiftUI
import CoreData

struct ExpenseFormView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    var selectedCategory: Category
    
    @State private var name = ""
    @State private var amount = ""
    @State private var quantity = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(selectedCategory.name ?? "nil").font(.title2)
            TextField("Name", text: $name)
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            TextField("Quantity", text: $quantity)
                .keyboardType(.numberPad)
            
            Button("Add New Expense") {
                dataManager.saveExpense(name: name, amount: amount, quantity: quantity, selectedCategory: selectedCategory)
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
            
        }
        .padding()
        .background(Color.creamB)
    }
}
