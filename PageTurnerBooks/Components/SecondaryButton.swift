//
//  SecondaryButton.swift


import SwiftUI

struct SecondaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Text(title)
        }
        .font(.system(size: 18, weight: .bold, design: .default))
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.ptSecondary)
        .foregroundColor(Color.white)
        .font(.system(size: 20, weight: .bold, design: .default))
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(title: "Test Button", action: {
            print("preview button tapped")})
        
    }
}
