//
//  Button.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 19/4/24.
//

import SwiftUI

struct LoadingButton<Content: View>: View{
    @Binding var loading: Bool
    let content: Content
    var action: () -> () = {}
    
    init(action: @escaping () -> Void, loading: Binding<Bool>, @ViewBuilder content: () -> Content){
        self._loading = loading
        self.content = content()
        self.action = action
        
    }
    
    var body: some View{
        Button(action: {
            if !loading{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    action()
                }
            }
            loading = true
        }){
            ZStack{
                if loading{
                    ProgressView()
                }else{
                    self.content
                }
            }
        }.disabled(loading).animation(.easeInOut, value: loading)
    }
}
