//
//  Int+Extension.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 2.10.22.
//

import Foundation
//Форматирую dt в dd MMM YYYY формат
extension Int {
    func decoderDt(format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    //Форматирование Int в DateComponents
    func decoderIntToDate() -> DateComponents {
        let timeInterval = TimeInterval(self)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: myNSDate)
    }
}
