//
//  AnswerDetailView.swift
//  C2
//
//  Created by MINJEONG on 4/16/25.
//

import SwiftUI

struct AnswerDetailView: View {
    
    var day: String
    @State private var records: [Record] = []
    @State private var recordToDelete: Record? //옵셔널(삭제할게 있을수도 없을수도)
    @State private var showingDeleteAlert = false
    
    @State private var recordToEdit: Record?//옵셔널(수정할게 있을수도 없을수도)
    @State private var isShowingEditView = false
    
    
    
    var body: some View {
        
        ZStack {
            Color("lightgray").ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("\(day)")
                    .font(.largeTitle)
                    .bold()
                    .padding(EdgeInsets(top: 40, leading: 25, bottom: -10, trailing: 25))
                    .foregroundColor(.deepbrown)
                
                if records.filter({ $0.day == day }).isEmpty { //답변 없을때 화면
                    VStack {
                        Spacer()
                        Text("No answer")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }else {
                    //답변있을때 화면
                    List {
                        Section {
                            // ForEach{record in}: 정렬된 기록들을 하나씩 꺼내서 record이름의 뷰로 표시
                            // filter: records 배열에서 현재 요일(day)과 같은 항목만 필터링
                            // sorted(by:): 필터링된 결과를 날짜(date) 기준으로 최신순 정렬
                            
                            ForEach(records.filter { $0.day == day }.sorted(by: { $0.date > $1.date })) { record in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(record.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(record.question)
                                        .font(.footnote)
                                        .foregroundColor(.deepbrown)
                                    
                                    Text(record.answer)
                                        .font(.body.bold())
                                        .foregroundColor(.deepbrown)
                                        .cornerRadius(10)
                                    
                                } // Tab해서 편집, 스와이프해서 삭제
                                .onTapGesture {
                                    recordToEdit = record
                                    isShowingEditView = true
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        //알람창
                                        recordToDelete = record
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showingDeleteAlert) {
                Button("삭제", role: .destructive) {
                    withAnimation(nil) {
                        if let record = recordToDelete { //if let: 옵셔널 안전하기 꺼내기 위해서 사용
                            delete(record)
                        }
                    }
                }
                Button("취소", role: .cancel) { } //취소하면 다른동작 필요없음
            } message: {
                Text(NSLocalizedString("삭제하면 복구할 수 없습니다.", comment: ""))
            }
        }
        .onAppear {
            loadRecords()
        }
        .sheet(item: $recordToEdit) { record in
            EditAnswerView(
                record: binding(for: record), //바인딩으로 넘겨야 수정시 반영됨
                onUpdate: updateRecord //클로저 형태로 전달
            )
        }
    }
    
    // ✅ 데이터 불러오기 함수: UserDefaults에 저장된 데이터를 불러와 records 배열에 복원
    private func loadRecords() {
        records = loadSavedRecords()
    }
    
    // ✅ 삭제 함수: 선택한 Record를 배열과 UserDefaults에서 삭제
    // records 배열에서 해당 record의 id와 일치하는 항목 제거
    // 변경된 records 배열을 JSON 형식으로 인코딩
    private func delete(_ record: Record) {
        records.removeAll { $0.id == record.id }
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "SavedRecords")
        }
    }
    
    // ✅ 업데이트 함수: 수정된 Record를 기존 records 배열에 반영, UserDefaults에 저장
    // 같은 id를 가진 Record가 배열에서 몇 번째에 있는지 찾고
    // 해당 위치의 데이터를 수정된 Record로 바꿈
    // 전체 records 배열을 다시 JSON으로 인코딩해서 UserDefaults에 저장
    private func updateRecord(_ updatedRecord: Record) {
        if let index = records.firstIndex(where: { $0.id == updatedRecord.id }) {
            records[index] = updatedRecord
            if let encoded = try? JSONEncoder().encode(records) {
                UserDefaults.standard.set(encoded, forKey: "SavedRecords")
            }
        }
    }

    // 특정 Record를 바인딩(Binding) 형태로 찾아서 반환하는 함수
    // records 배열 안에서 id가 같은 항목을 찾고, 해당 위치의 데이터를 바인딩으로 반환함, 수정 가능한 화면에서 사용
    private func binding(for record: Record) -> Binding<Record> {
        guard let index = records.firstIndex(where: { $0.id == record.id }) else {
            fatalError("Record not found") // 찾지 못하면 앱을 멈추게 함 (개발 중 에러 확인용)
        }
        return $records[index]
    }
}
    
    
#Preview {
    AnswerDetailView(day: "Saturday")
}
