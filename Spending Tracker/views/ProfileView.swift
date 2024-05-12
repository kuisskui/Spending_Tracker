import SwiftUI
import CoreData

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var username = ""
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Spacer()
            Text("Change Username").font(.title2)
            TextField("Change the name", text: $username).padding()
                .multilineTextAlignment(.center)
            Button("Change"){
                updateProfile(name: username)
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
    func updateProfile(name: String){
        dataManager.changeProfileName(name: username)
        dataManager.fetchProfile()
    }
    
}
