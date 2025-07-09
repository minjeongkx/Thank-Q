//
//  RecordManager.swift
//  Thank-Q
//
//  Created by MINJEONG on 7/9/25.
//


import Foundation
import SwiftUI

class RecordManager {
    static let shared = RecordManager()
    
    private init() {}

    // MARK: - Load
    /// UserDefaults에서 저장된 데이터를 불러와 [Record] 배열로 반환
    func loadRecords() -> [Record] {
        if let data = UserDefaults.standard.data(forKey: "SavedRecords"),
           let decoded = try? JSONDecoder().decode([Record].self, from: data) {
            return decoded
        }
        return []
    }

    // MARK: - Save
    /// DayEntry 데이터를 기반으로 새 Record를 생성하고 저장
    func saveRecord(from entry: DayEntry) {
        guard !entry.inputText.isEmpty else { return }
        
        var records = loadRecords()
        
        let selectedKey = questions[entry.pickedItem].key
        let localizedQuestion = Bundle.main.localizedString(forKey: selectedKey, value: nil, table: nil)
        
        let newRecord = Record(
            id: UUID(),
            date: Date(),
            day: entry.day,
            question: localizedQuestion,
            answer: entry.inputText
        )
        
        records.append(newRecord)
        
        if let encoded = try?  JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "SavedRecords")
        }
    }

    // MARK: - Delete
    /// 주어진 Record를 삭제하고 변경된 배열을 저장
    func delete(_ record: Record, from records: inout [Record]) {
        records.removeAll { $0.id == record.id }
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "SavedRecords")
        }
    }

    // MARK: - Update
    /// 기존 배열에서 주어진 Record를 찾아 업데이트하고 저장
    func updateRecord(_ updatedRecord: Record, in records: inout [Record]) {
        if let index = records.firstIndex(where: { $0.id == updatedRecord.id }) {
            records[index] = updatedRecord
            if let encoded = try? JSONEncoder().encode(records) {
                UserDefaults.standard.set(encoded, forKey: "SavedRecords")
            }
        }
    }

    // MARK: - Binding
    /// Record 배열 내 특정 요소를 바인딩으로 반환 (수정 뷰 등에서 사용)
    func binding(for record: Record, in records: Binding<[Record]>) -> Binding<Record> {
        guard let index = records.wrappedValue.firstIndex(where: { $0.id == record.id }) else {
            fatalError("Record not found")
        }
        return Binding(
            get: { records.wrappedValue[index] },
            set: { records.wrappedValue[index] = $0 }
        )
    }
}
