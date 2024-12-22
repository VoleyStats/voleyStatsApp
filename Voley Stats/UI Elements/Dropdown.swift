//
//  Dropdown.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 24/5/24.
//

import SwiftUI

struct Dropdown<T:Model>: View {
    
    @Binding var selection: T?
    @Binding var multiSelection: [T]
    let items: [T]
    let multi:Bool
    init(selection: Binding<[T]>, items: [T]){
        self._multiSelection = selection
        self._selection = .constant(nil)
        self.items = items
        self.multi = true
    }
    init(selection: Binding<T?>, items: [T]){
        self._selection = selection
        self._multiSelection = .constant([])
        self.items = items
        self.multi = false
    }
    @State var isPicking = false
//    @State var hoveredItem: SelectionValue?
//    @Environment(\.isEnabled) var isEnabled
    
    let buttonHeight: CGFloat = 44
    let arrowSize: CGFloat = 16
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        
        // Select Button - Selected item
        HStack {
            if multi {
                Text(multiSelection.isEmpty ? "pick.one".trad() : multiSelection.map{$0.description.trad()}.joined(separator: ", "))
                //            Text(selection.first?.description ?? "Select")
                    .lineLimit(1)
            }else{
                Text(selection?.description.trad() ?? "pick.one".trad()).lineLimit(1)
            }
//                .minimumScaleFactor(0.8)
            Spacer()
            Image(systemName: "chevron.right")
                .rotationEffect(isPicking ? Angle(degrees: -90) : Angle(degrees: 90))
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
        .frame(height: buttonHeight)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.white.opacity(0.1))
//                .stroke(.white, lineWidth: 2.2)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isPicking.toggle()
        }
        // Picker
        .overlay(alignment: .topLeading) {
            VStack {
                if isPicking {
                    Spacer(minLength: buttonHeight + 10)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(items, id:\.id) { item in
                                
                                Divider()
                                
//                                Button {
//                                    if self.selection.contains(item){
//                                        selection = selection.filter{$0 != item}
//                                    }else{
//                                        selection.append(item)
//                                    }
////                                    isPicking.toggle()
//                                    
//                                } label: {
                                    HStack{
                                        if self.multiSelection.contains(item) || selection == item{
                                            Image(systemName: "checkmark.circle")//.padding(.trailing)
                                        }
                                        Text(item.description.trad())
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.7)
                                            .frame(height: buttonHeight)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }.padding(.horizontal).foregroundStyle(.white).background(Color.swatch.dark.high).onTapGesture{
                                        if multi{
                                            if self.multiSelection.contains(item){
                                                multiSelection = multiSelection.filter{$0 != item}
                                            }else{
                                                multiSelection.append(item)
                                            }
                                        }else{
                                            if selection == item{
                                                selection = nil
                                            }else{
                                                selection = item
                                            }
                                            self.isPicking.toggle()
                                        }
                                    }
                                Divider()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .scrollIndicators(.never)
                    .frame(height: 200)
                    .background(Color.swatch.dark.high)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: cornerRadius)
//                        .stroke(Color.primary, lineWidth: 2.2)
//                    )
                    .transition(.scale(scale: 0.8, anchor: .top).combined(with: .opacity).combined(with: .offset(y: -10)))
                }
            }

        }
//        .padding(.horizontal, 12)
//        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.12), value: isPicking)
//        .sensoryFeedback(.selection, trigger: selection)
        .zIndex(999)
    }
}

//#Preview {
//    VStack {
//        Dropdown(selection: .constant([]), items: Match.all())
//    }
//    .preferredColorScheme(.dark)
//    .frame(width: 280, height: 280, alignment: .top)
//    .padding()
//}
