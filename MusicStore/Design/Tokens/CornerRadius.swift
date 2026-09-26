//
//  CornerRadius.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public enum CornerRadius: CGFloat, CaseIterable {
    /// 2pt
    case xxSmall = 2.0
    
    /// 4pt
    case xSmall = 4.0
    
    /// 6pt
    case small = 6.0
    
    /// 8pt
    case medium = 8.0
    
    /// 10pt
    case large = 10.0
    
    /// 12pt
    case xLarge = 12.0
    
    /// 14pt
    case xxLarge = 14.0
    
    /// 16pt
    case xxxLarge = 16.0
    
    /// 18pt
    case huge = 18.0
    
    /// The point value, for use where a `CGFloat` is expected.
    public var points: CGFloat { rawValue }
}
