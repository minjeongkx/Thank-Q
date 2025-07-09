//
//  AnswerCountView.swift
//  Thank-Q
//
//  Created by MINJEONG on 4/22/25.
//

import SwiftUI

//총답변개수 하단에 보여주기
struct AnswerCountView: View {
    @State private var allRecords: [Record] = []
    @State private var didAnswerToday: Bool = false

    var body: some View {
        HStack {
            Image(systemName: "applepencil.tip")
            Text("\(allRecords.count)")
        } .foregroundColor(didAnswerToday ? Color("deepbrown") : .gray)
        .onAppear {
            loadAnswer()
        }
    }

    func loadAnswer() {
        let decoded = loadSavedRecords() //저장된 답변불러오기
        allRecords = decoded

        let formatter = DateFormatter()//날짜를 문자열로 변환
        formatter.dateFormat = "yyyy-MM-dd"//어떤 형식으로 바꿀지 결정
        let today = formatter.string(from: Date()) //오늘 날짜의 문자열 형태
        didAnswerToday = decoded.contains {
            formatter.string(from: $0.date) == today
        } //contains 내부 조건 만족하면 true
    }
}

#Preview {
    ContentView()
}
