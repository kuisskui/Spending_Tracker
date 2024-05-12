import SwiftUI
import CoreData

struct ExpenseFormView: View {
    var selectedCategory: Category
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name = ""
    @State private var amount = ""
    @State private var quantity = ""
    
    @Environment(\.presentationMode) var presentationModel
    
    // Fetch request to retrieve all categories
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    // Access the managed object context
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(spacing: 20) {
            Text(selectedCategory.name ?? "nil").font(.title2)
            TextField("Name", text: $name)
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            TextField("Quantity", text: $quantity)
                .keyboardType(.numberPad)
            
            Button("Add New Expense") {
                saveExpense()
                presentationModel.wrappedValue.dismiss()
            }
            Spacer()
            Button("reset for dev"){
                DataManager().resetCoreData()
                dataManager.fetchCategories()
                dataManager.fetchExpenses()
            }
        }
        .padding()
        .background(Color.creamB)
        
    }
    
    private func saveExpense() {
        // Create a new instance of the Expense entity and set its attributes
        let newExpense = Expense(context: viewContext)
        newExpense.name = name
        newExpense.amount = Double(amount) ?? 0
        newExpense.quantity = Int16(quantity) ?? 0
        newExpense.category = selectedCategory // Set the selected category
        
        // Save the changes to the managed object context
        do {
            try viewContext.save()
            dataManager.fetchExpenses()
//            name = ""
//            amount = ""
//            quantity = ""
//            selectedCategory = nil // Reset the selected category
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
        
    }
    
}
