//
//  EmptyState.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 23/5/24.
//

import SwiftUI

struct EmptyState<Content: View>: View {
    var icon: Image
    var msg: String
    var width: CGFloat = 200
    @ViewBuilder var button: () -> Content
    var body: some View {
        VStack{
            icon.resizable().aspectRatio(contentMode: .fit).frame(width: width).foregroundStyle(.cyan).padding(.bottom)
            Text(msg)
            button().padding()
        }.font(.subheadline).padding().frame(maxWidth: .infinity, maxHeight: .infinity).padding()//.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
    }
}

//#Preview {
//    EmptyState(icon: Image(systemName: "person"), msg: "empty"){
//        Text("cta").foregroundStyle(.cyan)
//    }
//}
