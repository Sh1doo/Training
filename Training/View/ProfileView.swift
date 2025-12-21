//
//  ProfileView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/13.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    Color(.blue40)
                        .containerRelativeFrame(.vertical) { size, axis in size * 0.3
                        }
                        .ignoresSafeArea()
                    Color(Color.white)
                    
                }
                VStack{
                    HStack{
                        Spacer()
                        NavigationLink(destination: SettingView(model: profileViewModel), label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.blue100)
                                .padding()
                        })
                    }
                    
                    Spacer()
                    Image("profile_icon")
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.3
                        }
                    Text(profileViewModel.userdata.name).font(.largeTitle)
                    Text("Lv.\(profileViewModel.userdata.level)")
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
