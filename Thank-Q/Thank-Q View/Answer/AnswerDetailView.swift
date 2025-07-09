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
                            RecordManager.shared.delete(record, from: &records)
                        }
                    }
                }
                Button("취소", role: .cancel) { } //취소하면 다른동작 필요없음
            } message: {
                Text("삭제하면 복구할 수 없습니다.")
            }
        }
        .onAppear {
            records = RecordManager.shared.loadRecords()
        }
        .sheet(item: $recordToEdit) { record in
            EditAnswerView(
                record: RecordManager.shared.binding(for: record, in: $records), //바인딩으로 넘겨야 수정시 반영됨
                onUpdate: { updatedRecord in
                    RecordManager.shared.updateRecord(updatedRecord, in: &records)
                } //클로저 형태로 전달
            )
        }
    }
}
    
    
#Preview {
    AnswerDetailView(day: "Wednesday")
}
