//
//  EditAnswerView.swift
//  C2
//
//  Created by MINJEONG on 4/18/25.
//

import SwiftUI

struct EditAnswerView: View {
    
    @Binding var record: Record
    @Environment(\.dismiss) var dismiss
    
    var onUpdate: (Record) -> Void //클로저타입 변수 선언
    
    var body: some View {
        NavigationStack{
            VStack {
                TextEditor(text: $record.answer)
                    .padding()
                    .font(.sfsemi17)
                    .foregroundColor(.deepbrown)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(record.date.formatted(date: .abbreviated, time: .omitted))
                        .foregroundColor(.deepbrown)
                        .font(.sfsemi17)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onUpdate(record)//외부에서 전달된 함수 진행
                        dismiss()
                    }
                }
            }
            .foregroundColor(.deepbrown)
        }
    }
}

#Preview {
    EditAnswerView(
        record: .constant(Record(
            id: UUID(),
            date: Date(),
            day: "Monday",
            question: "Sample Question",
            answer: "Sample Answer"
        )),
        onUpdate: { _ in }
    )
}
