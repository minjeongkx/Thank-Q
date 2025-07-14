// MARK: - Thank-Q Widget Definition
//
//  thankq_wiget.swift
//  thankq_wiget
//
//  Created by MINJEONG on 7/10/25.
//

import Foundation
import WidgetKit
import SwiftUI


// MARK: - Widget Timeline Provider
/// `Provider`는 SwiftUI 위젯에서 데이터를 공급하는 핵심 구조입니다.
/// 이 구조체는 `TimelineProvider` 프로토콜을 채택하여,
/// 위젯이 어떤 데이터를 언제 표시할지를 결정합니다.
///
/// 구성 함수 설명:
/// - `placeholder`: 위젯이 로딩되기 전 표시되는 기본 콘텐츠 (예: 기록 수 0)
/// - `getSnapshot`: 미리보기(갤러리) 또는 위젯 추가 시 즉시 표시할 데이터 제공
/// - `getTimeline`: 실제 위젯 업데이트 타이밍에 사용할 데이터 타임라인 생성
///
/// `.atEnd` 정책은 추가 업데이트 없이 현재 상태만 표시하도록 지정합니다.
///
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), answerCount: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let count = RecordManager.shared.loadRecords().count
        let entry = SimpleEntry(date: Date(), answerCount: count)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let currentDate = Date()
        let count = RecordManager.shared.loadRecords().count
        print("👉 [Widget] Loaded records count: \(count)")
        let entry = SimpleEntry(date: currentDate, answerCount: count)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

// MARK: - Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let answerCount: Int
}

// MARK: - Widget View
struct thankq_wigetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var dayAbbreviation: String {
        todayDay().prefix(3).uppercased() // "MON", "TUE" 등
    }
    
    var body: some View {
        switch family {
        // MARK: - Small Widget UI
        case .systemSmall:
            
            VStack {
                // Icon with "Q"
                HStack {
                    Text("\(dayAbbreviation)")
                        .font(.shrink16)
                        .foregroundColor(.deepbrown)
                        .padding(.trailing, 60)
                    Text("Q")
                        .font(.shrink15)
                        .foregroundColor(.white)
                        .frame(width: 29, height: 29)
                        .background(Color("deepbrown"))
                        .cornerRadius(8)
                }
                // Count
                Text("\(entry.answerCount)")
                    .font(.shrink48)
                    .foregroundColor(.deepbrown)
                    .padding(.vertical, 5)
                
                HStack{
                    Image(systemName: "pencil.tip.crop.circle.badge.plus")
                    Text("New")
                }
                .font(.shrink15)
                .foregroundColor(.white)
                .frame(width: 140, height: 31)
                .background(Color("deepbrown"))
                .cornerRadius(20)
                .padding(.bottom, -5)
                
                
            }
            
        // MARK: - Medium Widget UI
        case .systemMedium:
            let records = RecordManager.shared.loadRecords()
            let calendar = Calendar(identifier: .gregorian)
            let weekdayInitials = ["S", "M", "T", "W", "T", "F", "S"]
            
            VStack(alignment: .leading) {
                    HStack{
                        Text("Moment of thanks")
                            .font(.shrink16)
                        Spacer()
                        Text("Q")
                            .font(.shrink16)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color("deepbrown"))
                            .cornerRadius(8)
                    }
                    Text("\(entry.answerCount)")
                        .font(.shrink48)
                        .padding(.vertical, 1)
                    
                    
                    
                    HStack(spacing: 5) {
                        ForEach(0..<7) { index in
                            let weekdaySymbol = weekdayInitials[index]
                            let now = Date()
                            let currentWeek = calendar.dateInterval(of: .weekOfYear, for: now)
                            let hasAnswer = records.contains { record in
                                guard let week = currentWeek else { return false }
                                let recordWeekday = calendar.component(.weekday, from: record.date)
                                let mappedIndex = (recordWeekday + 6) % 7
                                return mappedIndex == index && week.contains(record.date)
                            }
                            
                            VStack {
                                Text(weekdaySymbol)
                                    .font(.shrink12)
                                Image(systemName: hasAnswer ? "checkmark.circle.fill" : "circle.dashed")
                                    .frame(width:30)
                                
                            }
                        }
                    }

                    
                }.foregroundColor(.deepbrown)
                .padding(.leading, 10)
            
            
        default:
            EmptyView()
        }
    }
}

// MARK: - Widget Configuration
struct thankq_widget: Widget {
    let kind: String = "thankq_wiget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            thankq_wigetEntryView(entry: entry)
                .containerBackground(Color("widgetwhite"), for: .widget)
        }.supportedFamilies([.systemSmall, .systemMedium]) // ✅ Large 제외
            .configurationDisplayName("Thank-Q")
            .description("Thank-Q 바로가기 위젯을 추가하세요!")
    }
}


// MARK: - Widget Preview
#Preview(as: .systemSmall) {
    thankq_widget()
} timeline: {
    SimpleEntry(date: .now, answerCount: 20)
}

// MARK: - Widget Preview
#Preview(as: .systemMedium) {
    thankq_widget()
} timeline: {
    SimpleEntry(date: .now, answerCount: 30)
}
