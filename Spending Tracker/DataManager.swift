import CoreData
import SwiftUI
import Foundation
import Combine


/// Main data manager to handle the expense items
class DataManager: NSObject, ObservableObject {
    /// Published property to update the UI upon changes
    @Published var expenses: [Expense] = []
    @Published var categories: [Category] = []
    @Published var profile: Profile?
    
    /// Core Data container setup with the model name
    let container: NSPersistentContainer
    
    /// Default init method to configure and load the Core Data container
    override init() {
        // Initialize the NSPersistentContainer with the name of your Core Data Model
        container = NSPersistentContainer(name: "Model")
        
        super.init()
        
        // Load the persistent stores and handle potential errors
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Real applications should handle errors appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Call to load expenses from Core Data
        fetchExpenses()
        fetchCategories()
        fetchProfile()
    }
    
    func fetchExpenses(categoryName: String) -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        var temp: [Expense] = []
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.name, ascending: true)]
        request.predicate = NSPredicate(format: "category.name == %@", categoryName)

        do {
            temp = try container.viewContext.fetch(request)
            print("Fetched \(temp.count) expenses for category \(categoryName)")
        } catch {
            print("Error fetching expenses: \(error)")
        }
        return temp
    }

    
    /// Fetches expenses from Core Data and assigns them to the 'expenses' array
    func fetchExpenses() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()

        // You can specify sort descriptors or predicates here if necessary
        // request.sortDescriptors = [NSSortDescriptor(key: "attributeName", ascending: true)]

        do {
            // Execute the fetch request, and set the results to the published expenses array
            expenses = try container.viewContext.fetch(request)
        } catch {
            // Handle the fetch error appropriately in real apps
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func fetchCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()

        // You can specify sort descriptors or predicates here if necessary
        // request.sortDescriptors = [NSSortDescriptor(key: "attributeName", ascending: true)]

        do {
            // Execute the fetch request, and set the results to the published expenses array
            categories = try container.viewContext.fetch(request)
        } catch {
            // Handle the fetch error appropriately in real apps
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func fetchProfile() {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()

        // You can specify sort descriptors or predicates here if necessary
        // request.sortDescriptors = [NSSortDescriptor(key: "attributeName", ascending: true)]

        do {
            // Execute the fetch request, and set the results to the published expenses array
            profile = try container.viewContext.fetch(request).first
        } catch {
            // Handle the fetch error appropriately in real apps
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func changeProfileName(name: String){
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        do {
            // Perform the fetch request to get the entity
            let results = try container.viewContext.fetch(fetchRequest)
            if results.isEmpty {
                let newProfile = Profile(context: container.viewContext)
                newProfile.name = name
                
                do {
                    try container.viewContext.save()
                } catch {
                    print("Error saving expense: \(error.localizedDescription)")
                }
                
            }
            else {
                // Update the properties of the entity
                let profileToUpdate = results.first
                profileToUpdate?.name = name
                
                // Save the context
                try container.viewContext.save()
            }
        } catch {
            print("Failed to fetch or update the entity: \(error.localizedDescription)")
        }
    }
    
    /// Resets the Core Data store
    func resetCoreData() {
        let coordinator = container.persistentStoreCoordinator
        for store in coordinator.persistentStores {
            do {
                try coordinator.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
                try coordinator.addPersistentStore(ofType: store.type, configurationName: nil, at: store.url, options: nil)
            } catch {
                print("Reset error: \(error)")
            }
        }
    }
}
