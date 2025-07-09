//
//  DayEntry.swift
//  C2
//
//  Created by MINJEONG on 4/17/25.
//

import Foundation

struct DayEntry: Identifiable, Hashable {
    let id = UUID()
    let day: String
    var pickedItem: Int
    var inputText: String
}

//Hashable은 Swift가 DayEntry를 비교하거나, 고유하게 식별할 수 있도록 도와주는 프로토콜
//id: \.self를 쓰면, DayEntry 자체가 Hashable이어야 Swift가 “이게 어떤 항목인지” 판단할 수 있다
// → 즉, Hashable이 있어야 ForEach가 각 항목을 고유하게 인식

let initialDayEntries: [DayEntry] = [
    DayEntry(day: "Monday", pickedItem: 0, inputText: ""),
    DayEntry(day: "Tuesday", pickedItem: 0, inputText: ""),
    DayEntry(day: "Wednesday", pickedItem: 0, inputText: ""),
    DayEntry(day: "Thursday", pickedItem: 0, inputText: ""),
    DayEntry(day: "Friday", pickedItem: 0, inputText: ""),
    DayEntry(day: "Saturday", pickedItem: 0, inputText: ""),
    DayEntry(day: "Sunday", pickedItem: 0, inputText: "")
]
