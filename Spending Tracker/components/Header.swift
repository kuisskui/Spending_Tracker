//
//  Header.swift
//  Spending Tracker
//
//  Created by kuisskui on 8/5/2567 BE.
//

import SwiftUI

struct Header: View {
    let username: String
    
    var body: some View {
        VStack{
            Text(username)
                .font(.largeTitle)
                .foregroundStyle(Color.white)
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.redB)
        .padding(0)
    }
}

#Preview {
    Header(username: "Kaopong")
}
