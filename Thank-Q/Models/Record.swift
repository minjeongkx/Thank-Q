//
//  Record.swift
//  C2
//
//  Created by MINJEONG on 4/17/25.
//

import Foundation

struct Record: Identifiable, Codable {
    let id: UUID
    let date: Date
    let day: String
    let question: String
    var answer: String
}

//Codable: 구조체 JSON등으로 저장하거나 불러올 수 있도록 도와주는 프로토콜
