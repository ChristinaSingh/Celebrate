//
//  CalendarManager.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import Foundation
import UIKit


class CalendarManager:NSObject {
    
    static let shared = CalendarManager()
    var ipadWidth = 600
    private var calendar = Calendar(identifier: .islamicUmmAlQura)
    private var months:[Month] = []
    private var selectedDate: Date?
    
    private lazy var dateFormatter: DateFormatter = {
        return getDayFormatter()
    }()
    
    private var baseDate: Date = Date() {
      didSet {
          let days = generateDaysInMonth(for: baseDate).filter { day in
              self.isDateTodayOrLater(day.date)
          }
          let month = Month(days: days , date: baseDate, monthName: getMonthFormatter().string(from: baseDate))
          self.months.append(month)
      }
    }
    

    func isDateTodayOrLater(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let comparisonDate = calendar.startOfDay(for: date)
        
        return comparisonDate >= today
    }
    
    func getMonthHeight(month:Month) -> CGFloat {
        let width = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(ipadWidth) : UIScreen.main.bounds.width
        let rows = ceil(Double(month.days.count / 7))
        let dayHeight = ((width - 32.constraintMultiplierTargetValue.relativeToIphone8Width()) / 7) + 5.constraintMultiplierTargetValue.relativeToIphone8Height()
        let cellsHeight = (rows * dayHeight)
        return cellsHeight + 70.constraintMultiplierTargetValue.relativeToIphone8Height()
    }
    

    func getVisiableMonthIndex(calendarCV:UICollectionView) -> Int{
        var visibleRect = CGRect()
        visibleRect.origin = calendarCV.contentOffset
        visibleRect.size = calendarCV.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = calendarCV.indexPathForItem(at: visiblePoint) else { return 0 }
        return indexPath.row
    }
    
    private func generateMonth(){
        baseDate = self.calendar.date(
          byAdding: .month,
          value: 1,
          to: baseDate
        ) ?? baseDate
    }
    
    
    private func getDayFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: AppLanguage.currentAppleLanguage())
        return dateFormatter
    }
    
    
    private func getMonthFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: AppLanguage.currentAppleLanguage())
        return dateFormatter
    }
    
    
    private func getDayNameFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: AppLanguage.currentAppleLanguage())
        return dateFormatter
    }
    
    
    func getMonths(start:Date , count: Int ,selectedDate: Date? = nil , isIslamic:Bool = false) -> [Month]{
        if isIslamic {
            calendar = Calendar(identifier: .islamicUmmAlQura)
        }else{
            calendar = Calendar(identifier: .gregorian)
        }
        self.dateFormatter = getDayFormatter()
        self.months.removeAll()
        self.selectedDate = selectedDate
        self.baseDate = start
        for _ in 0...(count - 1) {
            self.generateMonth()
        }
        return months
    }
    
    func monthsInTwoDates(fDate: Date , tDate:Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: fDate, to: tDate)
        let numberOfMonths = (components.day! + 30) / 30
        return numberOfMonths
    }
    
    
    private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        // 2
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            // 3
            throw CalendarDataError.metadataGeneration
        }
        
        // 4
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 5
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    
//    private func generateDaysInMonth(for baseDate: Date) -> [Day] {
//        guard let metadata = try? monthMetadata(for: baseDate) else {
//            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
//        }
//        
//        let numberOfDaysInMonth = metadata.numberOfDays
//        let offsetInInitialRow = metadata.firstDayWeekday
//        let firstDayOfMonth = metadata.firstDay
//        let days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
//            .map { day in
//                // 4
//                let isWithinDisplayedMonth = day >= offsetInInitialRow
//                // 5
//                let dayOffset =
//                isWithinDisplayedMonth ?
//                day - offsetInInitialRow :
//                -(offsetInInitialRow - day)
//                return generateDay(
//                    offsetBy: dayOffset,
//                    for: firstDayOfMonth)
//            }
//
//        
//        return days
//    }
    
    
    private func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let firstDayOfMonth = metadata.firstDay
        
        let lastDayOfMonth = Calendar.current.date(byAdding: .day, value: numberOfDaysInMonth - 1, to: firstDayOfMonth)!
        
        let days: [Day] = (1...numberOfDaysInMonth)
            .map { day in
                let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
                return  Day(
                    date: date,
                    number: dateFormatter.string(from: date),
                    month: getMonthFormatter().string(from: date),
                    dayName: getDayNameFormatter().string(from: date),
                    isToday: isDateEqualToToday(date),
                    isSelected: DateFormatter.standard.string(from: date) == DateFormatter.standard.string(from: selectedDate ?? Date())
                )
            }
        
        let filteredDays = days.filter { day in
            return day.date >= firstDayOfMonth && day.date <= lastDayOfMonth
        }
        
        return filteredDays
    }
    
    
    func isDateEqualToToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        return dateComponents.year == todayComponents.year &&
            dateComponents.month == todayComponents.month &&
            dateComponents.day == todayComponents.day
    }

    
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
    
}
