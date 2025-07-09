//
//  RecordUtil.swift
//  Thank-Q
//
//  Created by MINJEONG on 4/22/25.
//

import Foundation
// ✅ 데이터 불러오기 함수: UserDefaults에 저장된 데이터를 불러와 records 배열에 복원
// "SavedRecords" 키로 저장된 데이터가 있는지 확인
// 데이터를 [Record] 타입으로 디코딩 시도
// 디코딩된 데이터를 records 배열에 저장
func loadSavedRecords() -> [Record] {
    if let data = UserDefaults.standard.data(forKey: "SavedRecords"),
       let decoded = try? JSONDecoder().decode([Record].self, from: data) {
        return decoded
    }
    return [] //데이터없음or디코딩 실패시 빈 배열 반환
}
