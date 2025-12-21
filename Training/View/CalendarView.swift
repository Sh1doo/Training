//
//  CalendarView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/23.
//

import SwiftUI

struct CalendarView: View {
    // Model
    @StateObject private var model = CalendarModel()
    @StateObject private var colorModel = ColorModel()
    @ObservedObject var trainingListModel: TrainingListModel

    // 編集中の日付 (全体共有用)
    @Binding var editingDate: Date

    var body: some View {
        VStack{
            // 月移動ヘッダー
            HStack {
                Button(action: {
                    model.adjustMonth(by: -1)
                }) {
                    Image(systemName: "arrowshape.left.circle.fill").foregroundStyle(Color.blue100)
                }
                Spacer()
                Text("\(model.formatMonth(from: model.calendarViewDate))")
                Spacer()
                Button(action: {
                    model.adjustMonth(by: 1)
                }) {
                    Image(systemName: "arrowshape.right.circle.fill").foregroundStyle(Color.blue100)
                }
            }
            
            //カレンダー本体
            LazyVGrid (columns: model.sevenColumns, spacing: 0) {
                ForEach(model.weekName, id:\.self) { col in
                    Rectangle()
                        .fill(Color.blue100)
                        .frame(height: 25)
                        .overlay(Text("\(col)").foregroundColor(.white))
                }
                
                //１行目の空白
                if model.firstdayWeekday > 1 {
                    ForEach(-10..<(model.firstdayWeekday - 1 - 10), id:\.self) { col in
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 50)
                    }
                }
                
                // 各日付のボタン
                ForEach(0..<model.lastDay, id: \.self) { col in
                    let colDateComponent = DateComponents(year: model.calendarViewDate.year, month: model.calendarViewDate.month, day: col+1)
                    
                    let isSelected = (model.selectedDay.day ?? 0) == col + 1 &&
                                     (model.selectedDay.year ?? 0) == model.calendarViewDate.year &&
                                     (model.selectedDay.month ?? 0) == model.calendarViewDate.month
                    
                    let isScheduled = !trainingListModel.getListedTrainingFromRealm(dateComponents:colDateComponent ).isEmpty
                    
                    let mark = trainingListModel.getTrainingLog(dateComponents: colDateComponent).mark
                    
                    VStack(spacing: 0){
                        ZStack{
                            //背景
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(isSelected ? Color.white20 : Color.white )
                                    .frame(width: 50, height: isScheduled ? 45 : 50)
                                
                                // 予定がある
                                if isScheduled {
                                    Rectangle()
                                        .foregroundStyle(colorModel.numberToColor(number: mark))
                                        .frame(height: 5)
                                }
                            }
                            
                            Text("\(col + 1)")
                                .foregroundStyle(Color.black)
                        } .onTapGesture { //単押し
                            model.selectedDay = model.calendarViewDate
                            model.selectedDay.day = col + 1
                            editingDate = calendar.date(from: model.selectedDay) ?? Date()
                            trainingListModel.listUpdate(editingDate: editingDate)
                            
                        }
                        
                        //アンダーライン
                        Rectangle()
                            .fill(Color.white100)
                            .frame(height: 1)
                    }
                }
            }
        }
        .onAppear(){
            // 最初に表示した時、カレンダーを現在の日付に合わせて更新する。
            model.calendarViewAppear()
        }
    }
}

#Preview {
    ContentView()
}
