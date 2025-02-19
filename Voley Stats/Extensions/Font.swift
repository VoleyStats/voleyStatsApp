//
//  SwiftUIView.swift
//
//
//  Created by Pau Hermosilla on 27/4/23.
//

import SwiftUI

extension Font{
    public static var largeTitle: Font{
        return Font.custom("Futura-medium", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
    public static var title: Font{
        return Font.custom("Futura-medium", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }
    public static var title2: Font{
        return Font.custom("Futura-medium", size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    }
    public static var title3: Font{
        return Font.custom("Futura-medium", size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
    }
    public static var body: Font{
        return Font.custom("Futura-medium", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
}

struct CustomFonts {
    public static func registerFonts() {
//        registerFont(bundle: Bundle.main , fontName: "Futura-bold", fontExtension: ".ttf")
        registerFont(bundle: Bundle.main , fontName: "Futura-medium", fontExtension: ".ttf")
//        registerFont(bundle: Bundle.main , fontName: "Neighbor", fontExtension: ".ttf")
//        registerFont(bundle: Bundle.main , fontName: "Neighbor-Bold", fontExtension: ".ttf")
//        registerFont(bundle: Bundle.main , fontName: "Neighbor-BoldItalic", fontExtension: ".ttf")
//        registerFont(bundle: Bundle.main , fontName: "Neighbor-Italic", fontExtension: ".ttf")
//        registerFont(bundle: Bundle.main , fontName: "Neighbor-Light", fontExtension: ".ttf")
//        registerFont(bundle: Bundle.main , fontName: "Neighbor-LightItalic", fontExtension: ".ttf")
    }
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

