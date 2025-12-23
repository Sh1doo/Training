//
//  TrainingListView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/19.
//

import SwiftUI

struct TrainingListView: View {
    @ObservedObject var model: TrainingListViewModel

    @State private var selectedBigCategory = BodyCategory.upperbody
    @State private var selectedSmallCategory = BodyCategory.none
    
    @State private var selectedItem = 1
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("検索", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            
            categoryTabs
            
            if selectedBigCategory != BodyCategory.none {
                smallCategoryTabs
                menuList
            }
        }
        .onAppear(){
            if !model.isFetched {
                Task {
                    await model.fetchTrainingMenus()
                    model.loadFavorite()
                }
            }
        }
    }


    private var categoryTabs: some View {
        HStack(spacing: 0) {
            ForEach(BodyCategory.bigCategories, id:\.self) { bigCategory in
                Button(action: {
                    selectedBigCategory = bigCategory
                }){
                    ZStack{
                        Rectangle()
                            .fill(Color.blue100)
                            .frame(height:40)
                        Text(bigCategory.rawValue)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }


    private var smallCategoryTabs: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(model.SwitchCategories(category: selectedBigCategory), id:\.self) { smallcategory in
                    Button(action: {
                        selectedSmallCategory = smallcategory
                    }){
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
                            Text(smallcategory.localized)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }


    private var menuList: some View {
        ScrollView {
            ForEach(model.filteredMenus) { menu in
                HStack{
                    Text(menu.name.localized)
                    Spacer()
                    
                    Button(action:{
                        model.toggleFavorite(menu: menu)
                    }){
                        ZStack{
                            Rectangle()
                                .frame(width: 50, height: 50)
                                //.foregroundStyle(model.isFavoriteArray[menu.name.rawValue] ?? true ? Color.pink : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Image(systemName: "hand.thumbsup.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                //.foregroundStyle(model.isFavoriteArray[menu.name.rawValue] ?? true ? Color.white : Color.white100)
                                .scaleEffect(x: -1, y: 1)
                        }
                    }.buttonStyle(.plain)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .background(Color.blue100)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    TrainingListView(model: TrainingListViewModel())
}
