//
//  DateExtensions.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Date {

    /// 当前日历
    public var calendar: Calendar {
        return Calendar.current
    }

    /// 当前世纪
    public var era: Int {
        return Calendar.current.component(.era, from: self)
    }

    /// 当前季度
    public var quarter: Int {
        return Calendar.current.component(.quarter, from: self)
    }

    /// 当前是这一年中的第几周
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    /// 当前是这个月第几周
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }

    /// 当前年份
    public var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .year, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前月份
    public var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .month, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前日期
    public var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .day, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前是周几
    public var weekday: Int {
        get {
            return Calendar.current.component(.weekday, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .weekday, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前小时
    public var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .hour, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前分钟
    public var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .minute, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前秒
    public var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .second, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前纳秒
    public var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .nanosecond, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// 当前毫秒
    public var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            if let date = Calendar.current.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }

    /// 判断时间是不是将来
    public var isInFuture: Bool {
        return self > Date()
    }

    /// 判断时间是不是过去
    public var isInPast: Bool {
        return self < Date()
    }

    /// 判断时间是不是今天
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    /// 判断时间是不是昨天
    public var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    /// 判断时间是不是明天
    public var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }

    /// 判断时间是不是周末
    public var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }

    /// 判断时间是不是这周
    public var isInWeekday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }

    /// ISO8601 格式化时间
    public var iso8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .posix
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    /// 约5分钟
    public var nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// 约10分钟
    public var nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// 约一刻钟
    public var nearestQuarterHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// 约半小时
    public var nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        return Calendar.current.date(from: components)!
    }

    /// 约1小时
    public var nearestHour: Date {
        if minute >= 30 {
            return beginning(of: .hour)!.adding(.hour, value: 1)
        }
        return beginning(of: .hour)!
    }

    /// 当前时区
    public var timeZone: TimeZone {
        return Calendar.current.timeZone
    }

    /// UNIX时间戳
    public var unixTimestamp: Double {
        return timeIntervalSince1970
    }

    /// 距离现在几分钟
    public var differenceMinToCurrent: Int {
        let dateComponent = Calendar.current.dateComponents([.minute], from: self, to: Date())
        return dateComponent.minute!
    }

    /// 距离现在几小时
    public var differenceHourToCurrent: Int {
        let dateComponent = Calendar.current.dateComponents([.hour], from: self, to: Date())
        return dateComponent.hour!
    }

}

// MARK: - Methods
public extension Date {

    /// Date加某个时间得到的时间
    public func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    /// Date自加
    public mutating func add(_ component: Calendar.Component, value: Int) {
        self = adding(component, value: value)
    }

    /// 改变时间的某一个属性
    public func changing(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(bySetting: component, value: value, of: self)
    }

    /// 时间的某个属性的开始
    public func beginning(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))

        case .minute:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self))

        case .hour:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: self))

        case .day:
            return Calendar.current.startOfDay(for: self)

        case .weekOfYear, .weekOfMonth:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))

        case .month:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: self))

        case .year:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: self))

        default:
            return nil
        }
    }

    /// 事件的某个属性的最后
    public func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date
        case .minute:
            var date = adding(.minute, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date
        case .hour:
            var date = adding(.hour, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date
        case .day:
            var date = adding(.day, value: 1)
            date = Calendar.current.startOfDay(for: date)
            date.add(.second, value: -1)
            return date
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date
        case .month:
            var date = adding(.month, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date
        case .year:
            var date = adding(.year, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date
        default:
            return nil
        }
    }

    /// 格式化字符串-只有日期
    public func dateString(ofStyle style: DateFormatter.Style = .short, and locale: Locale = .china) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }

    /// 格式化字符串-时间日期
    public func dateTimeString(ofStyle style: DateFormatter.Style = .short, and locale: Locale = .china) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }

    /// 判断时间是不是在当前的某个属性内
    public func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// 格式化字符串-只有时间
    public func timeString(ofStyle style: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }

    /// 格式化字符串-没有年份
    func noYesterdayTimeString(of style: DateFormatter.Style = .short, and locale: Locale = .china) -> String {
        let format = DateFormatter()
        format.locale = locale
        format.dateStyle = style
        format.timeStyle = style
        format.dateFormat = "MM-dd HH:mm"
        return format.string(from: self)
    }

    /// 格式化字符串-相对时间
    public func relativelyString(of style: DateFormatter.Style = .short, and locale: Locale = .china) -> String {
        let minString = locale == .china ? "分钟前" : " minutes ago"
        let hourString = locale == .china ? "小时前" : " hours ago"
        let yesterdayString = locale == .china ? "昨天 " : "Yesterday "
        let justNowString = locale == .china ? "刚刚" : "Just now"
        if self.isInToday {
            if self.differenceMinToCurrent < 5 {
                return justNowString
            } else if self.differenceHourToCurrent < 1 {
                return "\(self.differenceMinToCurrent)" + minString
            } else {
                return "\(self.differenceHourToCurrent)" + hourString
            }
        } else if self.isInYesterday {
            return yesterdayString + "\(self.timeString(ofStyle: .short))"
        } else if self.isInCurrent(.year) {
            return self.noYesterdayTimeString(of: style, and: locale)
        }
        return self.dateTimeString(ofStyle: style, and: locale)
    }
    
}

// MARK: - Initializers
public extension Date {
    
    /// Create a new date form calendar components.
    public init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond) {
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        
        if let date = calendar?.date(from: components) {
            self = date
        } else {
            return nil
        }
    }
    
    /// Create date object from ISO8601 string.
    public init?(iso8601String: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .posix
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: iso8601String) {
            self = date
        } else {
            return nil
        }
    }
    
    /// Create new date object from UNIX timestamp.
    public init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }
    
}
