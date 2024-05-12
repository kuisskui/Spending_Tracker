import SwiftUI

@main
struct Spending_TrackerApp: App {
    @StateObject private var dataManager = DataManager()

    init() {
        // Customize tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor(red: 128 / 255, green: 4 / 255, blue: 3 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }

    var body: some Scene {
        WindowGroup {
            VStack (spacing: 0){
                Header(username: dataManager.profile?.name ?? "Profile")
                TabView {
                    HomeView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }

                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person")
                                Text("Profile")
                            }
                        }
                }
                .accentColor(Color(red: 255 / 255, green: 235 / 255, blue: 202 / 255)) // Change color based on the selected tab
            }
            .environmentObject(dataManager)
            .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
