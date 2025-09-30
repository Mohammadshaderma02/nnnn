//
//  TextFieldView.swift
//  Runner
//
//  Created by Haya on 16/03/2024.
//

import SwiftUI

struct TextFieldView: View {

    @Binding
    var text: String
    var placeholder: LocalizedStringKey

    var body: some View {
        
        TextField(placeholder, text: $text)
            .foregroundColor(.black)
            .padding(10)
            .padding(.trailing, 20)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white)
            )
            .overlay(
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark.app.fill")
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(5)
                })
                .padding(.trailing, 3),
                alignment: .trailing
            )
    }
}

#Preview {

    VStack {
        TextFieldView(text: .constant("https://demo.w-id.cloud/api/tokenhttps://demo.w-id.cloud/api/token"), placeholder: "")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray)
}

