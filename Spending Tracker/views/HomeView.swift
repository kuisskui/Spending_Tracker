import SwiftUI
import CoreData

struct ExpenseSummary: Identifiable {
    let id = UUID()
    var category: Category
    var count: Int16
    var totalAmount: Decimal
}

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Text("Spending")
                    Spacer()
                    Text("\(dataManager.expenses.count.formatted()) Times")
                    
                }
                .padding(.vertical, 15)
                .font(.title2)
                .foregroundColor(Color.black)
                
                Divider()
                
                ForEach(fetchExpenseSummary()) { expense in
                    HStack{
                        NavigationLink(destination: TableView(selectedCategory: expense.category)) {
                            VStack(alignment: .leading){
                                Text(expense.category.name ?? "-")
                                Text("\(expense.count) times").font(.caption).foregroundColor(Color.gray).padding(.vertical, -20)
                            }
                            
                            Spacer()
                            Text("\(expense.totalAmount)")
                                .padding(.horizontal, 20) // Add padding around the text to form a circular shape
                                .padding(.vertical, 10)
                                .foregroundColor(.white) // Set the text color to white for better readability
                                .background(GeometryReader { geometry in
                                    Color.redB.cornerRadius(geometry.size.height / 2)
                                })
                        }
                        .foregroundColor(Color.black)
                    }
                    
                    Divider()
                }
                
                NavigationLink(destination: CategoryFormView()) {
                    Text("+")
                        .foregroundColor(.redB)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.creamB)
        }
        .accentColor(.redB)
    }
    
    func fetchExpenseSummary() -> [ExpenseSummary] {
        var summaries = [ExpenseSummary]()
        var category: Category
        var count = 0
        var totalAmount = Decimal(0) // Ensure 'amount' is of type Decimal for financial calculations
        
        for c in dataManager.categories {
            category = c
            count = 0
            totalAmount = Decimal(0) // Ensure 'amount' is of type Decimal for financial calculations
            
            for expense in dataManager.expenses {
                if category.name == expense.category?.name {
                    count += 1
                    totalAmount += Decimal(expense.quantity) * Decimal(expense.amount)
                }
            }
            
            // Create a new summary for each category and add it to the array
            let summary = ExpenseSummary(category: category, count: Int16(count), totalAmount: totalAmount)
            summaries.append(summary)
        }
        return summaries
    }
    
}
