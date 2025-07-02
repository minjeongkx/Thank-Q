//
//  AnswerListView.swift
//  C2
//
//  Created by MINJEONG on 4/16/25.
//

import SwiftUI

struct AnswerListView: View {
    //listRecords: Record 데이터 모델을 갖는 배열
    @State private var listRecords: [Record] = []
   
    
    var body: some View {
       
        NavigationStack{
            ZStack {
                Color("lightgray").ignoresSafeArea()
                List {
                    ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) { day in
                        
                        NavigationLink(destination: AnswerDetailView(day: day)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(day)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.deepbrown)
                                
                                let answerCount = listRecords.filter { $0.day == day }.count //savedRecords 중에서 day와 동일한 것만 골라서, 그 개수를 세는 것
                                
                                if answerCount > 0 {
                                    Text("\(answerCount) answer\(answerCount > 1 ? "s" : "")")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.deepbrown)
                                } else {
                                    Text("No answer")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                            Text("전체보기")
                            .font(.sfsemi17)
                                .foregroundStyle(.deepbrown)
                    }
                }
                
                .onAppear{
                    //데이터불러오기
                    loadRecords()
                }
            }
        }
        
    }


    
    
    //데이터불러오기 함수
    private func loadRecords() {
        listRecords = loadSavedRecords()
    }
}
#Preview {
    AnswerListView()
}
