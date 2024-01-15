//
//  View+Ext.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import SwiftUI

extension View {
    public func attributeBox(backgroundColor: Color) -> some View {
        modifier(AttributeBoxModifier(backgroundColor: backgroundColor))
    }
}
