//
//  ContentView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/11/18.
//

import SwiftUI

struct HomeView: View {
    @StateObject var trainingListViewModel = TrainingListViewModel()
    @StateObject var userModel = UserModel()
    
    //選択中の日付
    @State private var editingDate: Date = Date()
    
    @State private var isShowTimer = false

    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    _CalendarView(trainingListViewModel: trainingListViewModel, editingDate: $editingDate)
                        .padding()
                    
                    TodaysTraining(model: trainingListViewModel)
                    
                    Spacer()
                    
                    NavigationLink(destination: _MakeTrainingListView(model: trainingListViewModel, editingdate: editingDate)){
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
            TrainingListView(model: trainingListViewModel)
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
    @ObservedObject var model: TrainingListViewModel
    var body: some View {
        ZStack {
            VStack {
                //今日のメニュー
                ScrollView(showsIndicators: false) {
                    //Training List
                    ForEach(model.trainingList, id: \.self) { listItem in
                        HStack {
                            Rectangle()
                                .fill(Color.blue100)
                                .frame(width: 5)
                            Text(listItem.name).font(.title3).bold()
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
