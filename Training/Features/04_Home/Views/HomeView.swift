//
//  ContentView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/11/18.
//

import SwiftUI

struct HomeView: View {
    @StateObject var makeTrainingListViewModel = MakeTrainingListViewModel()
    @StateObject var userModel = UserModel()
    
    // 編集中の日付
    @State private var editingDate: Date = Date()
    
    @State private var isShowTimer = false

    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    _CalendarView(makeTrainingListViewModel: makeTrainingListViewModel, editingDate: $editingDate)
                        .padding()
                    
                    TodaysTraining(model: makeTrainingListViewModel)
                    
                    Spacer()
                    
                    NavigationLink(destination: _MakeTrainingListView(model: makeTrainingListViewModel, editingdate: editingDate)){
                        Text("編集")
                    }
                    .modifier(TrainingMenuButtonStyle())
                    .padding(.horizontal)
                    
                    Spacer()

                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            TrainingListView()
                .tabItem {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Workout")
                }
            RecordView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis.ascending")
                    Text("Record")
                }
            SNSView()
                .tabItem {
                    Image(systemName: "network")
                    Text("SNS")
                }
            
        }
    }
}

//本日のトレーニング
struct TodaysTraining: View {
    @ObservedObject var model: MakeTrainingListViewModel
    var body: some View {
        ZStack {
            VStack {
                //今日のメニュー
                ScrollView(showsIndicators: false) {
                    //Training List
                    ForEach(model.dayTrainingList, id: \.self) { listItem in
                        HStack {
                            Rectangle()
                                .fill(Color.blue100)
                                .frame(width: 5)
                            Text(listItem.name.localized).font(.title3).bold()
                            Spacer()
                            VStack (alignment: .trailing) {
                                HStack (spacing: 0){
                                    Text("\(listItem.weight)").monospaced()
                                    Text(" kg").foregroundStyle(Color.gray)
                                }
                                HStack (spacing: 0){
                                    Text("\(listItem.count)").monospaced()
                                    Text(" 回").foregroundStyle(Color.gray).frame(alignment: .leading)
                                }
                            }
                        }
                    }
                }
            }.padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
