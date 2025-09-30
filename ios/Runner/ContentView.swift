//  ContentView.swift
//  Runner
//
//  Created by Haya on 16/03/2024.
//

import SwiftUI
import ENMobileOCRSDK
import ENMobileVisionSDK
import Flutter

struct ContentView: View {

    @State private var openBar = false
    @State private var openMrz = false
    @State var openDoc = false
    @State private var openLivWithPhrases = false
    @State private var openLiv = false

    @State private var showDocumentCountryPicker = false
    @State private var showDocumentTypePicker = false
    @State private var showDocumentVersionPicker = false
    @State private var showResultView = false
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var openingLivWithPhrases = false
    @State private var openingLiv = false
    @State private var isShareSheetPresented = false

    @State private var results = ""
    @State private var facematch: (UIImage, Double)? = nil

    @State private var image: UIImage? = nil
    @State private var logFileURL: URL? = nil

    @StateObject var viewModel: ContentViewModel

    var onDismiss: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {

            ZStack {

                GeometryReader { screenProxy in
                    Color.white // Your background color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(0.5) // Adjust the opacity to control the color intensity
                .zIndex(0)



                    if let documentCountry = viewModel.documentCountry, let documentType = viewModel.documentType, let documentVersion = viewModel.documentVersion {
                        ReadDocumentView(documentCountry: documentCountry,
                                         documentType: documentType,
                                         documentVersion: documentVersion,
                                         isReadDocumentPresented: $openDoc, returnAcquiredImage: true, onBackPressed: {
                            onDismiss?()
                           // presentationMode.wrappedValue.dismiss()
                            print("back pressed haya")
                        }) { result in
                            parseOCRResult(result: result)
                        }
                    }


                    ReadMrzView(isReadMrzPresented: $openMrz, returnAcquiredImage: true, onBackPressed: {
                        print("back pressed")
                    }) { result in
                        parseOCRResult(result: result)
                    }

                    ReadBarcodeView(isReadBarcodePresented: $openBar, returnAcquiredImage: true, onBackPressed: {
                        print("back pressed")
                    }) { result in
                        parseOCRResult(result: result)
                    }

                    LivenessView(isLivenessPresented: $openLivWithPhrases,
                                 acquisitionDurationSeconds: 15,
                                 threshold: 0.9,
                                 faceMatchImageAndThreshold: facematch,
                                 phrases: ["FIRST SENTENCE", "SECOND SENTENCE", "THIRD SENTENCE"]) { result in
                        openingLivWithPhrases = false
                        facematch = nil
                        parseLivenessResult(result: result)
                    }

                    LivenessView(isLivenessPresented: $openLiv,
                                 acquisitionDurationSeconds: 5,
                                 threshold: 0.9,
                                 faceMatchImageAndThreshold: facematch,
                                 phrases: nil) { result in
                        openingLiv = false
                        facematch = nil
                        parseLivenessResult(result: result)
                    }

                    VStack(spacing: 0) {

                        VStack {
                        Color(red: 57/255, green: 33/255, blue: 86/255)
                                .frame(height: 35)
                                .padding(.top, screenProxy.safeAreaInsets.top - 10)


                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) ? 60 : 100, alignment: .center)
                        .background(Color(red: 57/255, green: 33/255, blue: 86/255))
                        .overlay(

                            Button(action: {
                              //  self.presentationMode.wrappedValue.dismiss()
                              //  self.onDismiss?()
                                onDismiss?()
                                
                                withAnimation {
                                    //if I use this expretion I can click back to main EKYC Screen menu
                                    //viewModel.currentSection = .mainMenu
                                    //if I use this expretion I can't click back to main EKYC Screen menu will stay in genericOCRMenu
                                    //viewModel.currentSection = .genericOCRMenu

                                }
                            }, label: { Text("EKYC Screen haya")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(Color(.enMediumGray))
                                    .padding()
                                    .padding(.leading, screenProxy.safeAreaInsets.leading)
                                    .padding(.top, screenProxy.safeAreaInsets.top - 10)
                            })
                            .opacity(viewModel.currentSection != .mainMenu ? 1 : 1),
                            alignment: .leading
                        )
                        .zIndex(10)
                        //6-6-2024
                        .onAppear{
                            onDismiss?()
                            print("EKYC Screen haya onAppear")
                        }


                        switch viewModel.currentSection {

                            case .mainMenu:

                                mainMenu(screenProxy: screenProxy)
                                    .transition(.move(edge: .leading))

                            case .genericOCRMenu:
                                    
                                genericOCRMenu(screenProxy: screenProxy)
                                    .transition(.move(edge: .trailing))

                            case .livenessFacematch:

                                livenessMenu(screenProxy: screenProxy)
                                    .transition(.move(edge: .trailing))

                            case .settingsMenu:

                                settingsMenu(screenProxy: screenProxy)
                                    .transition(.move(edge: .trailing))
                        }
                    }
                    .ignoresSafeArea(.container, edges: .all)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        //6-6-2024
           /* .sheet(isPresented: $showResultView) {
                ResultsView(result: $results)
               
            }*/
            .overlay(
                Group {

                    ZStack {

                        if showDocumentCountryPicker {

                            VStack {

                                VStack {
                                    Picker("Countries", selection: $viewModel.documentCountrySelected) {
                                        ForEach(viewModel.documentCountries, id: \.self) { country in
                                            Text(country)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .pickerStyle(.wheel)

                                    ButtonView(action: {
                                        withAnimation {
                                            viewModel.documentCountry = viewModel.documentCountrySelected
                                            showDocumentCountryPicker = false
                                        }
                                    }, label: "Ok")
                                    .padding([.bottom, .horizontal], 15)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.enBackgroundBlack))
                                )
                                .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.35))
                            .ignoresSafeArea()
                            .transition(.opacity)

                        }

                        if showDocumentTypePicker {

                            VStack {

                                VStack {
                                    Picker("Documents", selection: $viewModel.documentTypeSelected) {
                                        ForEach(viewModel.documentTypes, id: \.self) { type in
                                            Text(type)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .pickerStyle(.wheel)

                                    ButtonView(action: {
                                        withAnimation {
                                            viewModel.documentType = viewModel.documentTypeSelected
                                            showDocumentTypePicker = false
                                        }
                                    }, label: "Ok")
                                    .padding([.bottom, .horizontal], 15)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.enBackgroundBlack))
                                )
                                .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.35))
                            .ignoresSafeArea()
                            .transition(.opacity)

                        }

                        if showDocumentVersionPicker {

                            VStack {

                                VStack {
                                    Picker("Versions", selection: $viewModel.documentVersionSelected) {
                                        ForEach(viewModel.documentVersions, id: \.self) { version in
                                            Text(String(version))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .pickerStyle(.wheel)

                                    ButtonView(action: {
                                        withAnimation {
                                            viewModel.documentVersion = viewModel.documentVersionSelected
                                            showDocumentVersionPicker = false
                                        }
                                    }, label: "Ok")
                                    .padding([.bottom, .horizontal], 15)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.enBackgroundBlack))
                                )
                                .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.35))
                            .ignoresSafeArea()
                            .transition(.opacity)

                        }

                        if viewModel.isLoading {
                            VStack {
                                if #available(iOS 15.0, *) {

                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 57/255, green: 33/255, blue: 86/255)))
                                        .controlSize(.large)
                                        .tint(.black)

                                } else {

                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                        .scaleEffect(1.74)

                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.7))
                            .ignoresSafeArea()
                            .transition(.opacity)
                        }
                    }
                },
                alignment: .center
            )
            .sheet(isPresented: $shouldPresentImagePicker) {

                ImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                    .ignoresSafeArea()

            }
            .onChange(of: image) { image in

                guard let image = image else { return }

                facematch = (image, 0.8)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if openingLiv {
                        openLiv = true
                    } else if openingLivWithPhrases {
                        openLivWithPhrases = true
                    }
                }
            }
            .onChange(of: viewModel.initKOresult) { resultKO in

                if let resultKO = resultKO {
                    results = resultKO
                    showResultView = true
                }
            }

    }

    @ViewBuilder
    private func mainMenu(screenProxy: GeometryProxy) -> some View {
    

        ScrollView {
        

            VStack(spacing: 10) {

                Spacer()
                    .frame(height: 15)
                
                    

                Text("Setup")
                    .bold()
                    .font(.title)
                    .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                    .shadow(radius: 10)

                ButtonView(action: {
                    if !viewModel.sdkInitialized {
                        viewModel.initSDK() }
                }, label: "Init SDK")
                .frame(width: screenProxy.size.width * 0.8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .padding()
                        .opacity(viewModel.sdkInitialized ? 1 : 0),
                    alignment: .trailing
                )
                //to start initSDK without button
                //.onAppear {viewModel.initSDK()}
                Spacer()
                    .frame(height: 5)
                Text("OCR")
                      .bold()
                      .font(.title)
                      .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                      .shadow(radius: 10)
                
                
                ButtonView(action: {
                    
                    withAnimation {
                   // viewModel.currentSection = .genericOCRMenu
                    }
                    //openDoc = true

                }, label: "Generic OCR ALI")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(viewModel.sdkInitialized ? 1 : 0.4)
                    .disabled(!viewModel.sdkInitialized)
                    .onAppear {
                        viewModel.currentSection = .genericOCRMenu
                        openDoc = true
                            }

                Spacer()
                    .frame(height: 5)

                Text("OCR")
                    .bold()
                    .font(.title)
                    .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                    .shadow(radius: 10)

                ButtonView(action: { openBar = true }, label: "OCR Barcode")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(viewModel.sdkInitialized ? 1 : 0.4)
                    .disabled(!viewModel.sdkInitialized)

                ButtonView(action: { openMrz = true }, label: "OCR Mrz")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(viewModel.sdkInitialized ? 1 : 0.4)
                    .disabled(!viewModel.sdkInitialized)
                

               // ButtonView(action: {

                  //  withAnimation {
                        //viewModel.currentSection = .genericOCRMenu
                    ///}

               // }, label: "Generic OCR HAZAIMEH")
                   // .frame(width: screenProxy.size.width * 0.8)
                   // .opacity(viewModel.sdkInitialized ? 1 : 0.4)
                   // .disabled(!viewModel.sdkInitialized)

                Spacer()
                    .frame(height: 5)

                Text("Liveness/FaceMatch")
                    .bold()
                    .font(.title)
                    .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                    .shadow(radius: 10)

                ButtonView(action: {

                    withAnimation {
                        viewModel.currentSection = .livenessFacematch
                    
                       
                    }
                    // openLiv = true

                }, label: "Liveness/Facematch")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(viewModel.sdkInitialized ? 1 : 0.4)
                    .disabled(!viewModel.sdkInitialized) 
                //.onAppear {
                    //viewModel.currentSection = .livenessFacematch
                    //openLiv = true
                    //  }

                Spacer()
                    .frame(height: 5)

                Text("Other")
                    .bold()
                    .font(.title)
                    .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                    .shadow(radius: 10)

                ButtonView(action: { Task{
                    viewModel.isLoading = true
                    if let logFileURL = try? await ENMobileOCRSDK.shared.createLogsZipFile() {
                        self.logFileURL = logFileURL
                        isShareSheetPresented = true
                    }
                    viewModel.isLoading = false
                }}, label: "Create log zip")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(viewModel.sdkInitialized ? 1 : 0.4)
                    .disabled(!viewModel.sdkInitialized)
                    .sheet(item: $logFileURL) { logFileURL in
                        ShareSheetView(activityItems: [logFileURL])
                    }

                ButtonView(action: {

                    withAnimation {
                        viewModel.currentSection = .settingsMenu
                    }

                }, label: "Settings")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(viewModel.sdkInitialized ? 0.4 : 1)
                    .disabled(viewModel.sdkInitialized)

               // Spacer()
                //    .frame(height: 15)
               // ButtonView(action: {
                  //  print("back pressed")

                 // }, label: "Exit EKYC")
                 // .frame(width: screenProxy.size.width * 0.8)



                Spacer()
                    .frame(height: 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }


    @ViewBuilder
    private func genericOCRMenu(screenProxy: GeometryProxy) -> some View {

        GeometryReader { scrollViewProxy in

            ScrollView {

                VStack(spacing: 10) {

                    Spacer()
                        .frame(height: 15)

                    Text("Document Country")
                        .bold()
                        .font(.title)
                        .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                        .shadow(radius: 10)

                    ButtonView(action: {
                        withAnimation {
                            showDocumentCountryPicker = true
                        }
                    }, label: "jor")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    Text("Document Type")
                        .bold()
                        .font(.title)
                        .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                        .shadow(radius: 10)

                    ButtonView(action: {
                        withAnimation {
                            showDocumentTypePicker = true
                        }
                    }, label: "idc")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    Text("Document Version")
                        .bold()
                        .font(.title)
                        .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                        .shadow(radius: 10)

                    ButtonView(action: {
                        withAnimation {
                            showDocumentVersionPicker = true
                        }
                    }, label:  "1")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(minHeight: 15)

                    ButtonView(action: {
                        
                 
                       // openDoc = true
                    }, label: "Generic OCR HAYA")
                    .frame(width: screenProxy.size.width * 0.8)
                    .opacity(1)
                    

                    Spacer()
                        .frame(height: 30)

                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: scrollViewProxy.size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func livenessMenu(screenProxy: GeometryProxy) -> some View {

        GeometryReader { scrollViewProxy in

        ScrollView {

                VStack(spacing: 10) {

                    Spacer()

                    Spacer()
                        .frame(height: 30)

                    ButtonView(action: {
                        withAnimation {
                            openLiv = true
                        }
                    }, label: "Simple Liveness")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    ButtonView(action: {
                        withAnimation {

                            openingLiv = true
                            shouldPresentActionScheet = true
                        }
                    }, label: "Simple Liveness + Facematch")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    ButtonView(action: {
                        withAnimation {
                            openLivWithPhrases = true
                        }
                    }, label: "Liveness with Phrases")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    ButtonView(action: {
                        withAnimation {
                            openingLivWithPhrases = true
                            shouldPresentActionScheet = true
                        }
                    }, label: "Liveness with Phrases + Facematch")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 0)
                    .actionSheet(isPresented: $shouldPresentActionScheet) {

                        ActionSheet(title: Text("Choose mode"), message: Text("Please choose from where take the match picture"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                            self.shouldPresentImagePicker = true
                            self.shouldPresentCamera = true
                        }), ActionSheet.Button.default(Text("Photo Library"), action: {
                            self.shouldPresentImagePicker = true
                            self.shouldPresentCamera = false
                        }), ActionSheet.Button.cancel()])
                    }

                    Spacer()
                        .frame(height: 30)

                    Spacer()

                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: scrollViewProxy.size.height)

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func settingsMenu(screenProxy: GeometryProxy) -> some View {

        GeometryReader { scrollViewProxy in

            ScrollView {

                VStack(spacing: 10) {

                    Spacer()
                        .frame(height: 15)

                    HStack {
                        Text("OCR URL")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.ocrSDKConfiguration.ocrServiceUrl,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    HStack {
                        ButtonView(action: {
                            viewModel.setIdReconDevEnv()
                        }, label: viewModel.documentCountry ?? "Set EN Dev")
                        .frame(width: screenProxy.size.width * 0.4 - 3)

                        ButtonView(action: {
                            viewModel.setIdReconDevPreProd()
                        }, label: viewModel.documentCountry ?? "Set EN Preprod")
                        .frame(width: screenProxy.size.width * 0.4 - 3)
                    }

                    Spacer()
                        .frame(height: 5)

                    HStack {

                        Text("OCR Authentication URL")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.ocrSDKConfiguration.authenticationUrl,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    HStack {

                        Text("OCR Authentication Tenant")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.ocrSDKConfiguration.authenticationTenant,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    HStack {

                        Text("OCR Authentication User")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.ocrSDKConfiguration.authenticationUser,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)


                    HStack {
                        Text("OCR Authentication Password")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.ocrSDKConfiguration.authenticationPassword,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 30)


                    HStack {
                        Text("Vision URL")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.visionSDKConfiguration.visionServiceUrl,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)


                    Spacer()
                        .frame(height: 5)

                    HStack {

                        Text("Vision Authentication URL")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.visionSDKConfiguration.authenticationUrl,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)


                    HStack {
                        Text("Vision Authentication Tenant")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.visionSDKConfiguration.authenticationTenant,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    HStack {

                        Text("Vision Authentication User")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.visionSDKConfiguration.authenticationUser,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 5)

                    HStack {
                        Text("Vision Authentication Password")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color(red: 57/255, green: 33/255, blue: 86/255))
                            .shadow(radius: 10)

                        Spacer()
                    }
                    .frame(width: screenProxy.size.width * 0.8)

                    TextFieldView(text: $viewModel.visionSDKConfiguration.authenticationPassword,
                                  placeholder: "")
                    .frame(width: screenProxy.size.width * 0.8)

                    Spacer()
                        .frame(height: 30)

                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


    private func parseOCRResult(result: OCRResult) {
        print("parseOCRResult(result: OCRResult)")
        UserDefaults.standard.removeObject(forKey: "prettyPrintedResult")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            switch result {
                case .ok(let result, _, _):

                    var prettyPrintedResult = result
                    if let resultData =  result.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: resultData, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                             prettyPrintedResult = String(decoding: jsonData, as: UTF8.self)
                        }
                

                    results = prettyPrintedResult
               // print("Saving prettyPrintedResult to UserDefaults: \(prettyPrintedResult)")
                UserDefaults.standard.set(prettyPrintedResult, forKey: "prettyPrintedResult")
                
                    print(".....................................................................................")
                    print(results)
                    print(".....................................................................................")
                    //showResultView = true
                    showResultView = true
                
                sendResultToFlutter(result: results)
                case .cancel: ()

                case .sdkNotInitialized:

                    results = "sdkNotInitialized"
                    showResultView = true

                case .documentNotSupported:

                    results = "documentNotSupported"
                    showResultView = true

                case .cannotGetSupportedDocuments:

                    results = "cannotGetSupportedDocuments"
                    showResultView = true

                case .issueWithImages:

                    results = "issueWithImages"
                    showResultView = true

                case .error(let error):

                    results = "Error: \(error)"
                    showResultView = true
            }
        }
    }

    private func sendResultToFlutter(result: String) {
        let flutterViewController = UIApplication.shared.windows.first?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.example.flutter/native", binaryMessenger: flutterViewController.binaryMessenger)
        methodChannel.invokeMethod("sendResultOCR", arguments: result)
    }
    private func parseLivenessResult(result: LivenessResult) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            switch result {
                case .ok(let livenessResult, _):

                    var prettyPrintedResult = livenessResult
                    if let resultData =  livenessResult.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: resultData, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                             prettyPrintedResult = String(decoding: jsonData, as: UTF8.self)
                        }

                    results = prettyPrintedResult
                    showResultView = true

                case .cancel: ()

                case .sdkNotInitialized:

                    results = "sdkNotInitialized"
                    showResultView = true

                case .error(let error):

                    results = "Error: \(error)"
                    showResultView = true

                @unknown default: ()
            }
        }
    }
    

}


#Preview {
    ContentView(viewModel: ContentViewModel())
}

extension URL: Identifiable {
    public var id: String {
        self.absoluteString
    }
}




