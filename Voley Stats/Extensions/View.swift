import SwiftUI

extension View {
    func toast(show: Binding<Bool>, _ toastView: Toast) -> some View {
        self.modifier(ToastModifier.init(show: show, toastView: toastView))
    }
    
    @ViewBuilder
    func spotlight(_ id: Int, shape: SpotlightShape = .rectangle, roundedRadius: CGFloat = 0, text: String = "") -> some View{
        self
            .anchorPreference(key: BoundsKey.self, value: .bounds){
                [id:BoundsKeyProperties(shape: shape, anchor: $0, text: text, radius: roundedRadius)]
            }
    }
    
    @ViewBuilder
    func spotlightOverlay(show: Binding<Bool>, currentSpot: Binding<Int>, name: String = "")->some View {
        self.overlayPreferenceValue(BoundsKey.self) { values in
            GeometryReader{proxy in
                if let preference = values.first(where: {item in
                    item.key == currentSpot.wrappedValue
                }){
                    let screenSize = proxy.size
                    let anchor = proxy[preference.value.anchor]
                    Rectangle().fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .opacity(show.wrappedValue ? 1 : 0)
                        .overlay(alignment: .topLeading){
                            Text(preference.value.text).font(.title3).fontWeight(.semibold).foregroundStyle(.white)
                                .opacity(0).overlay{
                                    GeometryReader{proxy in
                                        let textSize = proxy.size
                                        Text(preference.value.text).font(.title3).fontWeight(.semibold).foregroundStyle(.white)
                                            .offset(x: (anchor.minX + textSize.width) > (screenSize.width - 15) ? -((anchor.minX + textSize.width) - (screenSize.width - 15)) : 0)
                                            .offset(y: (anchor.maxY + textSize.height) > (screenSize.height - 50) ? (textSize.height - (anchor.maxY - anchor.minY) + 15) : 15)
                                    }.offset(x: anchor.minX, y: anchor.maxY).opacity(show.wrappedValue ? 1 : 0)
                                }
                        }
                        .mask{
                            Rectangle().overlay(alignment: .topLeading){
                                let radius = preference.value.shape == .circle ? (anchor.width / 2) : preference.value.radius
                                RoundedRectangle(cornerRadius: radius, style: .continuous)
                                    .frame(width: anchor.width+10, height: anchor.height+10)
                                    .offset(x:anchor.minX-5, y:anchor.minY-5)
                                    .blendMode(.destinationOut)
                            }
                        }
                        .overlay(alignment: .bottom){
                            Text("skip".trad())
                                .onTapGesture {
                                    show.wrappedValue = false
                                    
                                    if name != ""{
                                        UserDefaults.standard.set(false, forKey: name)
                                    }
                                }
                                .offset(y: -30)
                                .opacity(show.wrappedValue ? 1 : 0)
                        }
                        .onTapGesture {
                            if currentSpot.wrappedValue < (values.count){
                                currentSpot.wrappedValue += 1
                            }else{
                                show.wrappedValue = false
                                
                                if name != ""{
                                    UserDefaults.standard.set(false, forKey: name)
                                }
                            }
                        }
//                    spotlightHelper(screenSize: screenSize, rect: anchor, show: show, currentSpot: currentSpot, properties: preference.value, skip:{
//                        show.wrappedValue = false
//                        
//                        if name != ""{
//                            UserDefaults.standard.set(false, forKey: name)
//                        }
//                    }){
////                        print("\(currentSpot.wrappedValue), \(values.count)")
//                        if currentSpot.wrappedValue < (values.count){
//                            currentSpot.wrappedValue += 1
//                        }else{
//                            show.wrappedValue = false
//                            
//                            if name != ""{
//                                UserDefaults.standard.set(false, forKey: name)
//                            }
//                        }
//                    }
                }
            }.ignoresSafeArea()
                .animation(.easeInOut, value: show.wrappedValue)
                .animation(.easeInOut, value: currentSpot.wrappedValue)
        }
    }
    
    @ViewBuilder
    func spotlightHelper(screenSize: CGSize, rect: CGRect, show: Binding<Bool>, currentSpot: Binding<Int>, properties: BoundsKeyProperties, skip: @escaping ()->(), onTap: @escaping ()->())->some View {
        Rectangle().fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .opacity(show.wrappedValue ? 1 : 0)
            .overlay(alignment: .topLeading){
                Text(properties.text).font(.title3).fontWeight(.semibold).foregroundStyle(.white)
                    .opacity(0).overlay{
                        GeometryReader{proxy in
                            let textSize = proxy.size
                            Text(properties.text).font(.title3).fontWeight(.semibold).foregroundStyle(.white)
                                .offset(x: (rect.minX + textSize.width) > (screenSize.width - 15) ? -((rect.minX + textSize.width) - (screenSize.width - 15)) : 0)
                                .offset(y: (rect.maxY + textSize.height) > (screenSize.height - 50) ? (textSize.height - (rect.maxY - rect.minY) + 15) : 15)
                        }.offset(x: rect.minX, y: rect.maxY).opacity(show.wrappedValue ? 1 : 0)
                    }
            }
            .mask{
                Rectangle().overlay(alignment: .topLeading){
                    let radius = properties.shape == .circle ? (rect.width / 2) : properties.radius
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .frame(width: rect.width+10, height: rect.height+10)
                        .offset(x:rect.minX-5, y:rect.minY-5)
                        .blendMode(.destinationOut)
                }
            }
            .overlay(alignment: .bottom){
                Text("skip".trad())
                    .onTapGesture {
                        skip()
                    }
                    .offset(y: -30)
                    .opacity(show.wrappedValue ? 1 : 0)
            }
            .onTapGesture {
                onTap()
            }
    }
}

enum SpotlightShape{
    case circle
    case rectangle
    case rounded
}

struct BoundsKey: PreferenceKey{
    static var defaultValue: [Int: BoundsKeyProperties] = [:]
    
    static func reduce(value: inout [Int : BoundsKeyProperties], nextValue: () -> [Int : BoundsKeyProperties]) {
        value.merge(nextValue()) {$1}
    }
}

struct BoundsKeyProperties{
    var shape: SpotlightShape
    var anchor: Anchor<CGRect>
    var text: String = ""
    var radius: CGFloat = 0
}
