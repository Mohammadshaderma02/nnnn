//
//  ButtonView.swift
//  Runner
//
//  Created by Haya on 16/03/2024.
//

import SwiftUI

struct ButtonView: View {

    let action: () -> Void
    let label: String

    var body: some View {


        Button(action: {

            action()

        }, label: {

            Text(label)
                .bold()
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 57/255, green: 33/255, blue: 86/255))
                )
        })
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 57/255, green: 33/255, blue: 86/255))
        )
    }
}


#Preview {
    ButtonView(action: {}, label: "Init SDK")
}

