//
//  DateUtility.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 06/08/2021.
//

import UIKit

class DateUtility: NSObject {

    static func formatedDate(date:String, From inputFormat : String , To outputFormat : String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        if let nsdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = outputFormat
            let outputDate = dateFormatter.string(from: nsdate)
            return outputDate
        }
        else{
            return nil
        }
    }
}
