//
//  ButtonView.swift
//  C2
//
//  Created by MINJEONG on 4/16/25.
//

import SwiftUI

struct ButtonView: View {
    
    @Binding var entry: DayEntry
    @State private var isNavigating = false
    var onSave: (() -> Void)? = nil //클로저를 저장하는 변수(매개변수 -> 반환값 없음)
    
    var body: some View {
        //상위뷰(ContentView)에서 NavigationStack으로 감싸고 있어서 없어도됨
        NavigationLink {
            AnswerDetailView(day: entry.day)
        } label: {
            Text("Next")
                .font(.sfsemi17)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(entry.inputText.isEmpty ? Color.gray.opacity(0.3) : Color("deepbrown")) //입력없으면 gray, 입력있으면 deepbrown
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 4)
        }
        .disabled(entry.inputText.isEmpty) //입력없을때 버튼 비활성화
        
        .padding(.horizontal, 25)
        .padding(.top, 10)
        .simultaneousGesture(TapGesture().onEnded { // 탭 완료시 실행할 코드
            saveRecord(from: entry) // 기록저장
            onSave?() //입력창 초기화, 질문 리셋
        })
    }
    
    
    // ✅ 저장함수: next 버튼 누르면 사용자가 작성한 답변을 기존 기록에 추가 및 저장
    func saveRecord(from entry: DayEntry) {
        // 답변이 비어있으면 저장하지 않고 종료
        guard !entry.inputText.isEmpty else { return }

        var records = loadSavedRecords()//저장된 기록 불러옴
        
        
        
        let newRecord = Record( //현재 입력값으로 새 Record 생성
            id: UUID(),
            date: Date(),
            day: entry.day,
            question: questions[entry.pickedItem],
            answer: entry.inputText
        )

        records.append(newRecord)  // 기존 기록 배열에 새 기록 추가

        // 전체 records를 JSON 형식으로 인코딩하고 UserDefaults에 저장
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "SavedRecords")
        }
    }

}

#Preview {
    ContentView()
}
