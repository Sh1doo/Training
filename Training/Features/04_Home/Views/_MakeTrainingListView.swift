//
//  MakeTrainingListView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/21.
//

import SwiftUI
import SwiftData
import RealmSwift

struct _MakeTrainingListView: View {
    @ObservedObject var model: MakeTrainingListViewModel
    // リスト作成中の日付
    let editingdate: Date
    
    @State private var selectedBigCategory =  BodyCategory.upperBody
    @State private var selectedSmallCategory = BodyCategory.none
    
    @State private var showSheet = false
    
    @State private var selectedWeight: [Int] = Array(repeating: 0, count: 50)
    @State private var selectedCount: [Int] = Array(repeating: 0, count: 50)
    
    var body: some View {
        VStack {
            categoryTabs

            if selectedBigCategory != BodyCategory.none {
                smallCategoryTabs
                menuList
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
                        ForEach(0..<model.dayTrainingList.count, id: \.self) { index in
                            VStack(alignment:.leading) {
                                Text("\(model.dayTrainingList[index].name)")
                                    .font(.headline)
                                HStack(spacing: 0) {
                                    Button(action:{
                                        selectedWeight[index] -= 10
                                        model.dayTrainingList[index].weight -= 10
                                    }) {
                                        Image(systemName: "chevron.left.2")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedWeight[index] -= 1
                                        model.dayTrainingList[index].weight -= 1
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    Group {
                                        Text("\(selectedWeight[index])")
                                            .monospaced()
                                        Text(" kg").foregroundStyle(Color.gray)
                                    }.frame(maxWidth: .infinity)
                                    
                                    Spacer()
                                    Button(action:{
                                        selectedWeight[index] += 1
                                        model.dayTrainingList[index].weight += 1
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedWeight[index] += 10
                                        model.dayTrainingList[index].weight += 10
                                    }) {
                                        Image(systemName: "chevron.right.2")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                }
                                HStack(spacing: 0) {
                                    Button(action:{
                                        selectedCount[index] -= 10
                                        model.dayTrainingList[index].count -= 10
                                    }) {
                                        Image(systemName: "chevron.left.2")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedCount[index] -= 1
                                        model.dayTrainingList[index].count -= 1
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    Group {
                                        Text("\(selectedCount[index])")
                                            .monospaced()
                                        Text(" 回").foregroundStyle(Color.gray)
                                    }.frame(maxWidth: .infinity)
                                    
                                    Spacer()
                                    Button(action:{
                                        selectedCount[index] += 1
                                        model.dayTrainingList[index].count += 1
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                    
                                    Button(action:{
                                        selectedCount[index] += 10
                                        model.dayTrainingList[index].count += 10
                                    }) {
                                        Image(systemName: "chevron.right.2")
                                            .modifier(StepperButtonStyle())
                                    }.buttonStyle(.plain)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            model.dayTrainingList.remove(atOffsets: indexSet)
                        }
                    }
                    
                    // 閉じるボタン
                    Button(action:{
                        showSheet.toggle()
                        
                        // Realmへの保存
                        model.saveToRealm(date: editingdate, list: model.dayTrainingList)
                    }){
                        ZStack{
                            Rectangle()
                                .fill(Color.blue100)
                                .ignoresSafeArea()
                                //.frame(maxWidth: .infinity, height: 50)
                            Text("トレーニングを保存する").foregroundStyle(Color.white)
                        }
                    }
                }.onAppear(){
                    for index in 0..<model.dayTrainingList.count {
                        selectedWeight[index] = model.dayTrainingList[index].weight
                        selectedCount[index] = model.dayTrainingList[index].count
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
    
    private var categoryTabs: some View {
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
    }

    /// 小カテゴリタブ
    private var smallCategoryTabs: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(model.SwitchCategories(category: selectedBigCategory.english), id:\.self) { smallcategory in
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
    }
    
    /// メニュー一覧
    private var menuList: some View {
        ScrollView {
            ForEach(model.trainingMenus.filter{$0.category == selectedSmallCategory}) { menu in
                HStack {
                    Text(menu.name.localized)
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
                    selectedWeight[model.dayTrainingList.count-1] = 30
                    selectedCount[model.dayTrainingList.count-1] = 10
                }
            }
        }
    }
    
}

#Preview {
    _MakeTrainingListView(model: MakeTrainingListViewModel(), editingdate: Date())
}
