//
//  ContentView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/11/18.
//

import SwiftUI

//CustomView-1（本日のトレーニング用のボタン）
struct TrainingMenuButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue100)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
    }
}

//CustomView-2（Stepper用のボタン）
struct StepperButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.black)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(in: RoundedRectangle(cornerRadius:10))
            .backgroundStyle(Color.white20)
    }
}

//CustomModifier
extension View {
    func trainingMenuButtonStyle() -> some View {
        self.modifier(TrainingMenuButtonStyle())
    }
    
    func stepperButtonStyle() -> some View {
        self.modifier(StepperButtonStyle())
    }
}

struct ContentView: View {
    @StateObject var trainingListModel = TrainingListModel()
    @StateObject var userModel = UserModel()
    
    //選択中の日付
    @State private var editingDate: Date = Date()
    
    @State private var isShowTimer = false

    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    CalendarView(trainingListModel: trainingListModel, editingDate: $editingDate)
                        .padding()
                    
                    TodaysTraining(model: trainingListModel)
                    
                    Spacer()
                    
                    NavigationLink(destination: MakeTrainingListView(model: trainingListModel, editingdate: editingDate)){
                        Text("編集")
                    }
                    .trainingMenuButtonStyle()
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
            TrainingListView(model: trainingListModel)
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
    @ObservedObject var model: TrainingListModel
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
    ContentView()
}
