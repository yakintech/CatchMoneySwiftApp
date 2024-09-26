//
//  DateHelper.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 26.09.2024.
//

import Foundation


class DateHelper{
    
 
    static func formatDate(_ dateString: String) -> String {
        
        let dateFormatter: ISO8601DateFormatter = {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return formatter
            }()
            
            let displayFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM yyyy EEEE HH:mm"
                formatter.locale = Locale(identifier: "en_US")
                return formatter
            }()

        
            if let date = dateFormatter.date(from: dateString) {
                return displayFormatter.string(from: date)
            } else {
                return dateString  // Eğer dönüştürülemiyorsa orijinal stringi gösterir
            }
        }
}


