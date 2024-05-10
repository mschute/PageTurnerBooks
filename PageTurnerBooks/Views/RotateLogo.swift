//
//  RotateLogo.swift

import SwiftUI

struct RotateLogo: View {
    @State private var isRotating = false
    
    var body: some View {
        Image("PageLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(Animation.linear(duration: 25)
                .repeatForever(autoreverses: false), value: isRotating)
            .onAppear {
                withAnimation(.none){
                    isRotating = true
                }
                
            }
    }
}


#Preview {
    RotateLogo()
}
