//
//  _Search.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/30.
//

import SwiftUI

struct _SearchView: View {
    @StateObject private var model = _SearchViewModel()
    
    @FocusState private var searchFieldIsFocused: Bool
 
    @State private var showTagList = false
    @State private var showUpperBody = false
    @State private var showLowerBody = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Image(systemName: "magnifyingglass")
                    .onTapGesture {
                        // 検索
                    }
                TextField("検索", text: $model.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($searchFieldIsFocused)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            
            if showTagList {
                tagList
            }
            
            Spacer()
        }
        // タグリスト表示切り替え
        .onChange(of: searchFieldIsFocused) {
            showTagList.toggle()
        }
    }
    
    private var tagList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                
                // 大カテゴリ
                VStack(alignment: .leading, spacing: 1) {
                    // 上半身カテゴリ
                    Text("部位")
                    TagButton(title: CategoryTag.upperbody.localized, isSelected: $model.isSelected[CategoryTag.upperbody.sortOrder]) {
                        showUpperBody.toggle()
                        model.toggleTag(CategoryTag.upperbody)
                    }

                    if showUpperBody {
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(CategoryTag.upperCategories, id:\.self) { upperCategory in
                                TagButton(title: upperCategory.localized, isSelected: $model.isSelected[upperCategory.sortOrder]) {
                                    model.toggleTag(upperCategory)
                                }
                            }
                        }
                    }
                    
                    // 下半身カテゴリ
                    TagButton(title: CategoryTag.lowerbody.localized, isSelected: $model.isSelected[CategoryTag.lowerbody.sortOrder]) {
                        showLowerBody.toggle()
                        model.toggleTag(CategoryTag.lowerbody)
                    }
                    
                    if showLowerBody {
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(CategoryTag.lowerCategories, id:\.self) { lowerCategory in
                                TagButton(title: lowerCategory.localized, isSelected: $model.isSelected[lowerCategory.sortOrder]) {
                                    model.toggleTag(lowerCategory)
                                }
                            }
                        }
                    }
                }

                // 器具カテゴリ
                VStack(alignment: .leading, spacing: 1) {
                    Text("器具")
                    ForEach(CategoryTag.equipmentCategories, id:\.self) { equipmentCategory in
                        TagButton(title: equipmentCategory.localized, isSelected: $model.isSelected[equipmentCategory.sortOrder]) {
                            model.toggleTag(equipmentCategory)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    // その他カテゴリ
                    Text("その他")
                    ForEach(CategoryTag.specialCategories, id:\.self) { specialCategory in
                        TagButton(title: specialCategory.localized, isSelected: $model.isSelected[specialCategory.sortOrder]) {
                            model.toggleTag(specialCategory)
                        }
                    }
                    // POFカテゴリ
                    Text("POF区分")
                    ForEach(CategoryTag.pofCategories, id:\.self) { pofCategory in
                        TagButton(title: pofCategory.localized, isSelected: $model.isSelected[pofCategory.sortOrder]) {
                            model.toggleTag(pofCategory)
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    _SearchView()
}
