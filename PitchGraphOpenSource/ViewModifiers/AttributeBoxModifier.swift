//
//  AttributeBoxModifier.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import SwiftUI

struct AttributeBoxModifier: ViewModifier {
    var backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .font(.system(size: 10))
            .foregroundColor(Color(uiColor: .systemBackground))
            .padding(2)
            .background(backgroundColor)
            .cornerRadius(4)
    }
}
