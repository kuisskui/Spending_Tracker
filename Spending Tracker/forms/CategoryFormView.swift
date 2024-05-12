import SwiftUI
import CoreData

struct CategoryFormView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var category = ""
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Category", text: $category)
            
            Button("Add New Category") {
                saveCategory() // Call the saveCategory method when the button is tapped
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .padding()
        .background(Color.creamB)
    }
    
    private func saveCategory() {
        // Ensure the category name is not empty
        guard !category.isEmpty else { return }
        
        // Create a new Category managed object and set its properties
        let newCategory = Category(context: viewContext)
        newCategory.name = category
        
        // Save the changes to the managed object context
        do {
            try viewContext.save()
            dataManager.fetchCategories()
            // Optionally, you can reset the category variable to clear the text field after saving
            category = ""
        } catch {
            // Handle the error if saving fails
            print("Error saving category: \(error.localizedDescription)")
        }
    }
}

struct CategoryFormView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFormView()
    }
}
