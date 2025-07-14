//
//  FontResource.swift
//  Thank-Q
//
//  Created by MINJEONG on 6/18/25.
//

import Foundation
import SwiftUI

extension Font {
    //MARK: 영어,숫자
    enum SfPro {
        case bold
        case semibold
        case regular
        
        var value: String {
            switch self {
                /// SF Pro
            case .bold:
                return "SFProText-Bold"
            case .semibold:
                return "SFProText-SemiBold"
            case .regular:
                return "SFProText-Regular"
                
            }
        }
    }
    
    static func sfpro(type: SfPro, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    //MARK: SF Compact 변수들
    static var sfbold24: Font {
        return .sfpro(type: .bold, size: 24)
    }
    static var sfsemi12: Font {
        return .sfpro(type: .semibold, size: 12)
    }
    static var sfsemi17: Font {
        return .sfpro(type: .semibold, size: 17)
    }
    static var sfsemi30: Font {
        return .sfpro(type: .semibold, size: 30)
    }
    static var sfreg12: Font {
        return .sfpro(type: .regular, size: 12)
    }
    
    static var sfreg14: Font {
        return .sfpro(type: .regular, size: 14)
    }
    static var sfreg17: Font {
        return .sfpro(type: .regular, size: 17)
    }
    
    //MARK: Shrink hand
    enum Shrink {
        case regular
        var value: String {
            switch self {
                /// Shrink
            case .regular:
                return "Shrikhand-Regular"
            }
        }
    }
    static func shrink(type: Shrink, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var shrink12: Font {
        return .shrink(type: .regular, size: 12)
    }
    static var shrink15: Font {
        return .shrink(type: .regular, size: 15)
    }
    static var shrink16: Font {
        return .shrink(type: .regular, size: 16)
    }
    static var shrink48: Font {
        return .shrink(type: .regular, size: 48)
    }
    static var shrink50: Font {
        return .shrink(type: .regular, size: 50)
    }


}
