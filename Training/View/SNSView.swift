//
//  SNSView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/12.
//

import SwiftUI

struct SNSView: View {
    @StateObject var model = SNSViewModel()
    
    @State private var isPresentedAddFriendPage = false
    var body: some View {
        VStack {
            ZStack {
                Color.blue100.ignoresSafeArea()
                    .frame(height:60)
                Text("フレンド一覧")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
            }
            ScrollView(.vertical) {
                ForEach( model.friends, id:\.self) { friend in
                    ZStack {
                        Rectangle()
                            .frame(width: .infinity, height: 50)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 3, x: 0, y: 3)
                        
                        HStack(spacing: 0) {
                            Group {
                                Text("\(friend.level)")
                                    .font(.title)
                                Text("\(friend.name)")
                            }.padding(.leading)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Last Training \(friend.lastTraining)")
                                    .foregroundStyle(Color.gray)
                                    .fontWidth(.compressed)
                                Text("Last Login \(model.getFormattedDate(date: friend.lastLogin))")
                                    .foregroundStyle(Color.gray)
                                    .fontWidth(.compressed)
                            }
                            .padding(.horizontal)
                        }.padding(.horizontal)
                    }
                }
            }
            HStack {
                Button(action:{}){
                    Image(systemName: "trash").foregroundStyle(Color.red)
                    Text("フレンド削除").foregroundStyle(Color.red)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background{
                    Rectangle()
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                }
                
                Button(action:{
                    isPresentedAddFriendPage.toggle()
                }){
                    Image(systemName: "plus.app").foregroundStyle(Color.blue)
                    Text("フレンド追加").foregroundStyle(Color.blue)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background{
                    Rectangle()
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                }
            }
        }
        .padding(.bottom)
        
        //フレンド追加ページ
        .sheet(isPresented: $isPresentedAddFriendPage) {
            addFriendView(model: model)
        }
    }
}

struct addFriendView: View {
    @ObservedObject var model: SNSViewModel
    @State private var friendId: String = ""
    
    var body: some View {
        VStack( alignment: .leading, spacing: 3) {
            Text("IDを入力")
            HStack {
                TextField("ID", text: $friendId)
                    .frame(height: 50)
                    .keyboardType(.asciiCapable)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("追加"){
                    model.addFriend(id: friendId)
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    SNSView()
}
