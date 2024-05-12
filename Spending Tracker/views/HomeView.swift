import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    
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
                
                ForEach(dataManager.fetchExpenseSummary()) { expense in
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
    
    
    
}
