//
//  foundation.swift
//  C2
//
//  Created by MINJEONG on 4/15/25.
//

import Foundation

func todayDay() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "EEEE"
    return formatter.string(from: Date())
}







