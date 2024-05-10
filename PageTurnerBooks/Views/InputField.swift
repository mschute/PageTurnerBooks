//
//  InputField.swift

import SwiftUI

struct InputField: View {
    @Binding var text: String
    var title: String
    var placeholder: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.subheadline)
            
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .textContentType(isSecureField ? .oneTimeCode : nil)
                    
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    
            }
            
            Divider()
        }
    }
}

struct InputField_Previews: PreviewProvider {
    @State static var text = ""

    static var previews: some View {
        InputField(text: $text, title: "Test Title", placeholder: "Enter your text", isSecureField: false)
    }
}
