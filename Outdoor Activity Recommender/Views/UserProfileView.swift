//
//  SwiftUIView.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 29/12/2020.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profile View")
        .navigationBarTitle(Text("Your Profile"))
        }
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
