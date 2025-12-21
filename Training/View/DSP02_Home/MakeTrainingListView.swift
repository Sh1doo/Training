//
//  MakeTrainingListView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/21.
//

import SwiftUI
import SwiftData
import RealmSwift

struct MakeTrainingListView: View {
    @ObservedObject var model: TrainingListModel
    // リスト作成中の日付
    let editingdate: Date
    
    @State private var selectedBigCategory =  LocalizedText(english: "upperbody", japanese: "上半身")
    @State private var selectedSmallCategory = LocalizedText(english: "none", japanese: "none")
    
    @State private var showSheet = false
    
    @State private var selectedWeight: [Int] = Array(repeating: 0, count: 50)
    @State private var selectedCount: [Int] = Array(repeating: 0, count: 50)
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(model.bigCategories, id:\.self) { bigCategory in
                    Button(action: {
                        selectedBigCategory = bigCategory
                    }){
                        ZStack{
                            Rectangle()
                                .fill(Color.blue100)
                                .frame(height:40)
                            Text(bigCategory.japanese)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            
            //細かい分類のタブ
            if selectedBigCategory.english != "none" {
                ScrollView(.horizontal){
                    HStack{
                        ForEach(model.SelectCategories(category: selectedBigCategory.english), id:\.self) { smallcategory in
                            Button(action: {
                                selectedSmallCategory = smallcategory
                            }){
                                //Rectangle().stroke().frame(minWidth: 100, maxHeight: 30)
                                HStack{
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray)
                                            .frame(width: 15)
                                        if selectedSmallCategory == smallcategory {
                                            Circle()
                                                .fill(Color.blue40)
                                                .frame(width: 10)
                                        }
                                    }
                                    Text(smallcategory.japanese)
                                        .foregroundStyle(Color.black)
                                    
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                
                //トレーニング種目のデータ一覧
                ScrollView {
                    ForEach(model.trainingMenus.filter{$0.category == selectedSmallCategory.english}) { menu in
                        HStack {
                            Text(menu.name)
                                .padding()
                            Spacer()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.blue100)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onTapGesture {
                            model.addTrainingList(menu: menu)
                            selectedWeight[model.trainingList.count-1] = 30
                            selectedCount[model.trainingList.count-1] = 10
                        }
                    }
                }
            }
            
            Spacer()
            //現在追加されているトレーニングの確認
            Button(action:{
                showSheet.toggle()
            }){
                ZStack{
                    Rectangle()
                        .fill(Color.blue100)
                        .frame(height: 50)
                    Text("追加したトレーニングを確認する").foregroundStyle(Color.white)
                }
            }
            
            .sheet(isPresented: $showSheet){
                
                VStack {
                    List {
                        ForEach(0..<model.trainingList.count, id: \.self) { index in
                            VStack(alignment:.leading) {
                                Text("\(model.trainingList[index].name)")
                                    .font(.headline)
                                HStack(spacing: 0) {
                                    Button(action:{
                                        selectedWeight[index] -= 10
                                        model.trainingList[index].weight -= 10
                                    }) {
                                        Image(systemName: "chevron.left.2")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedWeight[index] -= 1
                                        model.trainingList[index].weight -= 1
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    Group {
                                        Text("\(selectedWeight[index])")
                                            .monospaced()
                                        Text(" kg").foregroundStyle(Color.gray)
                                    }.frame(width: .infinity)
                                    
                                    Spacer()
                                    Button(action:{
                                        selectedWeight[index] += 1
                                        model.trainingList[index].weight += 1
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedWeight[index] += 10
                                        model.trainingList[index].weight += 10
                                    }) {
                                        Image(systemName: "chevron.right.2")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                }
                                HStack(spacing: 0) {
                                    Button(action:{
                                        selectedCount[index] -= 10
                                        model.trainingList[index].count -= 10
                                    }) {
                                        Image(systemName: "chevron.left.2")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedCount[index] -= 1
                                        model.trainingList[index].count -= 1
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    Group {
                                        Text("\(selectedCount[index])")
                                            .monospaced()
                                        Text(" 回").foregroundStyle(Color.gray)
                                    }.frame(width: .infinity)
                                    
                                    Spacer()
                                    Button(action:{
                                        selectedCount[index] += 1
                                        model.trainingList[index].count += 1
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedCount[index] += 10
                                        model.trainingList[index].count += 10
                                    }) {
                                        Image(systemName: "chevron.right.2")
                                            .stepperButtonStyle()
                                    }.buttonStyle(.plain)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            model.trainingList.remove(atOffsets: indexSet)
                        }
                    }
                    
                    // 閉じるボタン
                    Button(action:{
                        showSheet.toggle()
                        
                        // Realmへの保存
                        model.saveToRealm(date: editingdate, list: model.trainingList)
                    }){
                        ZStack{
                            Rectangle()
                                .fill(Color.blue100)
                                .ignoresSafeArea()
                                .frame(width: .infinity, height: 50)
                            Text("トレーニングを保存する").foregroundStyle(Color.white)
                        }
                    }
                }.onAppear(){
                    for index in 0..<model.trainingList.count {
                        selectedWeight[index] = model.trainingList[index].weight
                        selectedCount[index] = model.trainingList[index].count
                    }
                }
            }
            
        }.onAppear(){
            if !model.isFetched {
                Task {
                    await model.fetchTrainingMenus()
                }
            }
        }
    }
}

#Preview {
    MakeTrainingListView(model: TrainingListModel(), editingdate: Date())
}
