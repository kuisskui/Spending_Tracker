import SwiftUI
import CoreData

struct TableView: View {
    var selectedCategory: Category
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    
    let categoryName = "Food"
    let username = "kuisskui"
    
    var body: some View {
        VStack(spacing: 10){
            HStack{
                VStack{
                    Text(selectedCategory.name ?? "nil").font(.title2)
                    
                }
                Spacer()
                
                Text("\(dataManager.fetchExpenses(categoryName: selectedCategory.name ?? "").count.formatted()) times").font(.caption).foregroundColor(Color.gray)
                
                Spacer()
                
                NavigationLink(destination: ExpenseFormView(selectedCategory: selectedCategory)) {
                    Text("New")
                }.padding(.horizontal, 20) // Add padding around the text to form a circular shape
                    .padding(.vertical, 10)
                    .foregroundColor(.white) // Set the text color to white for better readability
                    .background(GeometryReader { geometry in
                        Color.redB.cornerRadius(geometry.size.height / 2)
                    })
            }.padding(.top, -20)
            
            Divider()
            
            HStack {
                Text("Name").font(.title3)
                Spacer()
                Text("Quantity").font(.title3)
                Spacer()
                Text("Amount").font(.title3)
            }.foregroundColor(Color.redB)
            
            Divider()
            ForEach(dataManager.fetchExpenses(categoryName: selectedCategory.name ?? "")) { expense in
                HStack {
                    NavigationLink(destination: ExpenseView(expense: expense)){
                        Text(expense.name ?? "")
                        Spacer()
                        Text("\(expense.quantity)")
                        Spacer()
                        Text(String(format: "%.2f THB", expense.amount))
                    }
                    .foregroundColor(Color.black)
                }
                
                Divider()
                
            }
            if dataManager.fetchExpenses(categoryName: selectedCategory.name ?? "").count == 0{
                Button("Delete") {
                    deleteCategory(category: selectedCategory)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .foregroundColor(.white) // Set the text color to white for better readability
                .background(GeometryReader { geometry in
                    Color.redB.cornerRadius(geometry.size.height)
                })
            }
            
            Spacer()
        }
        .padding()
        .background(Color.creamB)
        
    }
    func deleteCategory(category: Category) {
        dataManager.container.viewContext.delete(category)
        do {
            try dataManager.container.viewContext.save()
            print("Successfully deleted expense.")
            // Re-fetch the data to update the UI
            dataManager.fetchCategories()
        } catch {
            print("Error saving context after deleting expense: \(error)")
            dataManager.container.viewContext.rollback() // Rollback any changes if save fails
        }
    }
    
}
