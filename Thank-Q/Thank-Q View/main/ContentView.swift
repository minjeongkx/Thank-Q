//
//  ContentView.swift
//  C2
//
//  Created by MINJEONG on 4/15/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var dayEntries: [DayEntry] = initialDayEntries
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("lightgray").ignoresSafeArea()
                
                VStack {
                    ScrollView{
                        VStack(spacing: 8) {
                        //    타이틀 및 앱 설명
                            Image("title")
                                .padding(.top, 20)
                                .padding(.bottom, 15)
                                .bold()
                            Text("\"A Question Of Thanks\"")
                                .bold()
                                .font(.subheadline)
                            
                            Text("원하는 요일에 앱을 열고, 감사질문에 답해보세요.\n매일 써야한다는 부담없이, 천천히 쌓아가면됩니다.")
                                .font(.sfreg14)
                                .lineSpacing(4)
                            
                            
                        }.foregroundColor(.deepbrown)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.init(top: 20, leading: 25, bottom: 40, trailing: 25))
                        
                        //오늘요일 나오기
                        //바인딩 타입의 값은 외부값 묶어서 참조이므로 wrappedValue로 실제값 접근
                        if let entryBinding = $dayEntries.first(where: { $0.wrappedValue.day == todayDay() }) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack{
                                    Text("\(entryBinding.wrappedValue.day)")
                                        .font(.sfbold24)
                                        
                                        .padding(.leading, 30)
                                        .foregroundColor(.deepbrown)
                                    
                                    Spacer()
                                    
                                    //전체보기 버튼
                                    
                                    NavigationLink(destination: AnswerListView()) {
                                        //Label("전체 보기", systemImage: "list.bullet")
                                        Text("전체 보기")
                                            .font(.sfsemi17)
                                            .foregroundColor(.deepbrown)
                                    }
                                    .padding(.trailing, 39)
                                    
                                }
                                //질문 및 입력상자 구성
                                VStack(alignment: .leading, spacing: 1) {
                                    
                                    //질문 픽커뷰
                                    PickerView(entry: entryBinding)
                                        .padding([.top, .leading], 13)
                                    //PickerView entry에, 현재 요일에 해당하는 DayEntry를 바인딩 형태로 넘기는 것
                                        
                                   
                                    //입력받기
                                    ZStack(alignment: .topLeading) {
                                        TextEditor(text: entryBinding.inputText)
                                            .padding(8)
                                            .font(.sfsemi17)
                                            .foregroundColor(.deepbrown)
                                        
                                        if entryBinding.inputText.wrappedValue.isEmpty {
                                            Text("Enter Answer")
                                                .foregroundColor(.lightbrown)
                                                .font(.sfsemi17)
                                                .padding(12)
                                        }
                                    }
                                }
                                .background(Color.white)
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .cornerRadius(20)
//                                .shadow(color:.gray.opacity(0.25),radius: 10, x: 0, y: 5)
                                .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 4)
                                .padding(.horizontal, 25)
                                
                                //next 버튼 뷰 구현
                            
                             ButtonView(entry: entryBinding) {
                                      if let index = dayEntries.firstIndex(where: { $0.day == entryBinding.wrappedValue.day }) { //클로저
                                          dayEntries[index].inputText = "" //텍스트 초기화로 되돌리기
                                          dayEntries[index].pickedItem = 0 //질문선택 초기화로 되돌리기
                                      }
                                  }
                            }
                        }
                        
                    }
                    AnswerCountView()
                }
            }
            
        }
    }
    
}



#Preview("🇰🇷 Korean") {
    ContentView()
        .environment(\.locale, .init(identifier: "ko"))
}

#Preview("🇺🇸 English") {
    ContentView()
        .environment(\.locale, .init(identifier: "en"))
}
