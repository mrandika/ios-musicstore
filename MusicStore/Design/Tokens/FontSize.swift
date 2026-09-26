//
//  FontSize.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public enum FontSize: CGFloat, CaseIterable {
    /// 10pt
    case xxSmall = 10.0
    
    /// 12pt
    case xSmall = 12.0
    
    /// 14pt
    case small = 14.0
    
    /// 16pt
    case medium = 16.0
    
    /// 18pt
    case large = 18.0
    
    /// 20pt
    case xLarge = 20.0
    
    /// 22pt
    case xxLarge = 22.0
    
    /// 24pt
    case xxxLarge = 24.0
    
    /// The point value, for use where a `CGFloat` is expected.
    public var points: CGFloat { rawValue }
}
