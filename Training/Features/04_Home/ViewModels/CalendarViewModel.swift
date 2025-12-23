//
//  CalendarModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/23.
//

import Foundation
import SwiftUI

// 全体で使用するカレンダー
let calendar = Calendar.current

class CalendarViewModel: ObservableObject {
    
    let sevenColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    let weekName = ["日", "月", "火", "水", "木", "金", "土"]
    // 月の日数
    @Published var lastDay = 30
    // 初日の曜日
    @Published var firstdayWeekday = 0
    // 選択中の日付
    @Published var selectedDay = DateComponents(year: 2024, month: 1, day: 1)
    
    // 表示する月を管理するための日付
    var calendarViewDate = DateComponents(year: 2024, month: 1, day: 1)
    
    private var isFirstAppear = true

    
    /// カレンダーの初期化
    func calendarViewAppear() {
        if isFirstAppear {
            calendarViewDate = calendar.dateComponents([.year, .month, .day], from: Date())
            updateCalendar()
            
            if let unrappedDay = calendarViewDate.day {
                selectedDay.day = unrappedDay
            }
            isFirstAppear = false
        }
    }
    
    
    /// カレンダーの更新
    private func updateCalendar(){
        if let range = calendar.range(of: .day, in: .month, for: calendar.date(from: calendarViewDate) ?? Date()) {
            lastDay = range.count
        }
        
        let tmp = calendarViewDate.day
        calendarViewDate.day = 1
        
        if let date = calendar.date(from: calendarViewDate) {
            firstdayWeekday = calendar.component(.weekday, from: date)
        }
        
        calendarViewDate.day = tmp
    }
    
    /// 表示する月の更新
    func adjustMonth(by value: Int){
        if let date = calendar.date(from: calendarViewDate) {
            if let newDate = calendar.date(byAdding: .month, value: value, to: date) {
                calendarViewDate = calendar.dateComponents([.year, .month, .day], from: newDate)
            }
        }
        updateCalendar()
    }
    
    /// 年月の表示をフォーマット
    func formatMonth(from components: DateComponents) -> String {
        if let date = calendar.date(from: components) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月"
            return formatter.string(from: date)
        }
        return "Invalid date"
    }
}
