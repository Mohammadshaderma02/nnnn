//
//  ResultsView.swift
//  Runner
//
//  Created by Haya on 16/03/2024.
//

import SwiftUI

struct ResultsView: View {

    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss

    @Binding var result: String

    var body: some View {

        GeometryReader { screenProxy in

            ZStack {

                VStack(spacing: 0) {

                    VStack {
                     Color(red: 57/255, green: 33/255, blue: 86/255)
                                                   .frame(height: 35)
                                                   .padding(.top, screenProxy.safeAreaInsets.top - 10)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) ? 60 : 100, alignment: .center)
                    .background(Color(.enBackgroundBlack))
                    .overlay(

                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: { Text("EKYC Screen Haya")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color(.enMediumGray))
                                .padding()
                                .padding(.leading, screenProxy.safeAreaInsets.leading)
                                .padding(.top, screenProxy.safeAreaInsets.top - 10)
                        }),
                        alignment: .leading
                    )
                    .zIndex(10)

                    ScrollView {
                        Text(result)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding()
                            .onAppear {
                                                       print("ResultsView appeared with result: \(result)")
                                                      // presentationMode.wrappedValue.dismiss()
                                                   }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ResultsView(result: .constant("""
                                  {
                                  "code" : "8006783232",
                                  "type" : "CODE128",
                                  "uuid" : "2ee1786a-b26c-4a74-80cd-7c5d008c0e7e"
                                  }
                                  """
))
}


