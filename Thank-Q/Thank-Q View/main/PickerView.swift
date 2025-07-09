//
//  PickerView.swift
//  C2
//
//  Created by MINJEONG on 4/15/25.
//
import SwiftUI

struct PickerView: View {
    
    @Binding var entry: DayEntry
    

    var body: some View {
       
     
            Menu {
                ForEach(0..<questions.count, id: \.self) { index in
                    Button(action: {
                        entry.pickedItem = index
                    }) {
                        Text(questions[index].localized)
                            .font(.footnote)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                   Text(questions[entry.pickedItem].localized)
                        .font(.footnote)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.sfsemi12)
                }.foregroundColor(.deepbrown)
            }
    
        
    }
}

#Preview {
    PickerView(entry: .constant(DayEntry(day: "Saturday", pickedItem: 0, inputText: "")))
        .environment(\.locale, .init(identifier: "ko"))
}
#Preview {
    PickerView(entry: .constant(DayEntry(day: "Saturday", pickedItem: 0, inputText: "")))
        .environment(\.locale, .init(identifier: "en"))
}
