//
//  SettingView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/12.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var model: ProfileViewModel

    @State private var instantId = ""
    @State private var name = ""
    
    var body: some View {
        Form {
            Section("UserInfo") {
                HStack {
                    Text("名前:")
                    TextField(model.userdata.name, text: $name)
                }
                HStack {
                    Text("ID:")
                    TextField(model.userdata.instant_id, text: $instantId)
                        .keyboardType(.asciiCapable)
                }
                Button("更新する") {
                    model.updateUserData(name: name, instantId: instantId)
                    instantId = ""
                    name = ""
                }
            }
            
            Section("Account") {
                Button("サインアウト") {
                    authViewModel.signOut()
                }.foregroundStyle(Color.red)
            }
            
            Section("email") {
                Text(model.getEmail())
                Button("e-mailを更新する") {
                    model.updateEmail()
                }
            }
            Section("password") {
                Text("******")
                Button("パスワードを更新する") {
                    model.updateEmail()
                }
            }
            Section("user") {
                Button("ユーザーを消去する") {
                    model.deleteUser()
                }.foregroundStyle(Color.red)
            }
            Section("Debug") {
                Text("Last Login: \(model.getLastLogin())")
                Text("Last Training: \(model.userdata.last_training)")
                Text("Display name:  \(model.userdata.name)")
                Text("id: \(model.userdata.id ?? "nil")")
                Text("level: \(model.userdata.level)")
                Text("instant-id: \(model.userdata.instant_id)")
            }
        }
    }
}

#Preview {
    SettingView(model: ProfileViewModel())
}
