import SwiftUI
import CoreData

struct ExpenseView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var expense: Expense
    
    var body: some View {
        VStack(spacing: 10){
            Text("Expense").font(.title2)
            HStack{
                Text("Name: ").foregroundStyle(Color.redB)
                Spacer()
                
                Text(expense.name ?? "None")
            }
            HStack{
                Text("Quantity: ").foregroundStyle(Color.redB)
                Spacer()
                
                
                Text(expense.quantity.formatted())
            }
            HStack{
                Text("Amount: ").foregroundStyle(Color.redB)
                Spacer()
                
                Text(expense.amount.formatted())
            }
            Button("Delete") {
                deleteExpense(expense: expense)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .foregroundColor(.white) // Set the text color to white for better readability
            .background(GeometryReader { geometry in
                Color.redB.cornerRadius(geometry.size.height)
            })
            
            Spacer()
            
        }
        .padding(.top, -20)
        .padding()
        .background(Color.creamB)
        
    }
    func deleteExpense(expense: Expense) {
        dataManager.container.viewContext.delete(expense)
        do {
            try dataManager.container.viewContext.save()
            print("Successfully deleted expense.")
            // Re-fetch the data to update the UI
            dataManager.fetchExpenses()
        } catch {
            print("Error saving context after deleting expense: \(error)")
            dataManager.container.viewContext.rollback() // Rollback any changes if save fails
        }
    }
    
}
