//
//  ContentViewModel.swift
//  Runner
//
//  Created by Haya on 16/03/2024.
//

import Foundation
import Combine
import ENMobileOCRSDK
import ENMobileVisionSDK

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

@MainActor
class ContentViewModel: ObservableObject {

    enum Section {
        case mainMenu
        case genericOCRMenu
        case livenessFacematch
        case settingsMenu
    }

    @Published
    var currentSection: Section = .mainMenu {
        willSet {
            if newValue == .genericOCRMenu {
                self.resetGenricOCRDocuments()
            }
        }
    }

    @Published
    var isLoading = false

    
    @Published
    var sdkInitialized = false
    
    @Published
    var haya = "test"
  

    @Published
    var documentCountry: String? {
        didSet {
            self.documentTypes = Array(Set(supportedDocuments.filter{ ($0.country == documentCountry || documentCountry == nil)}.map {  $0.type } )).sorted()
            self.documentVersions = Array(Set(supportedDocuments.filter{ ($0.country == documentCountry  || documentCountry == nil)}.map {  $0.version } )).sorted()
            self.documentType = nil
            self.documentVersion = nil
        }
    }

    var documentCountrySelected: String {
        get {
            return (self.documentCountry != nil ? self.documentCountry! : self.documentCountries.first)!
        }

        set {
            self.documentCountry = newValue
        }
    }

    @Published
    var documentCountries: [String] = []

    @Published
    var documentType: String? {
        didSet {
            self.documentVersions = Array(Set(supportedDocuments.filter{ ($0.type == documentType || documentType == nil) && ($0.country == documentCountry || documentCountry == nil) }.map {  $0.version } )).sorted()
            if self.documentVersion != nil, !documentVersions.contains(documentVersion ?? -1) { self.documentVersion = nil }
        }
    }

    var documentTypeSelected: String {
        get {
            return (self.documentType != nil ? self.documentType! : self.documentTypes.first)!
        }

        set {
            self.documentType = newValue
        }
    }

    @Published
    var documentTypes: [String] = []

    @Published
    var documentVersion: Int? {
        didSet {
            //
        }
    }

    var documentVersionSelected: Int {
        get {
            return (self.documentVersion != nil ? self.documentVersion! : self.documentVersions.first)!
        }

        set {
            self.documentVersion = newValue
        }
    }

    @Published
    var documentVersions: [Int] = []

    var genericOCREnabled: Bool {
        self.documentCountry != nil && self.documentType != nil && self.documentVersion != nil
        
    }


    @Published
    var ocrSDKConfiguration = Configuration(ocrServiceUrl: isPreview ? "mock" : "https://dev.euronovate.com:58889/v2",
                                            authenticationUrl: "https://demo.w-id.cloud/api/token",
                                            authenticationTenant: "wid",
                                            authenticationUser: "idcrecon@euronovate.com",
                                            authenticationPassword: "ruAP4eMkJceTtvAiLmeX",
                                            customizedColors: nil,
                                            customizedStrings: nil,
                                            localization: "en",
                                            logLevel: .debug,
                                            removeLogsOlderThanDays: 10,
                                            enAuthServerUrl: nil,
                                            enAuthLicenseKey: nil,
                                            enAuthJwt: "eyJhbGciOiJSUzI1NiJ9.eyJlbmMiOnsiYWRkIjp7fSwicHJkIjoie1wiRU5fTUFQX0lPU19NT0JEU0tcIjp7XCJwcmNcIjpcIk1BUElPU1wiLFwicHJzXCI6XCJNT0JEU0tcIixcImNzdFwiOm51bGwsXCJleHBwcmRcIjoxNzIyNDYzMjAwMDAwLFwidXByXCI6W1wiUkVBREVSXCJdLFwiaXNzXCI6MTY5MDU0NjU4ODA0NCxcImV4cHRrblwiOjB9LFwiRU5fTUFQX0FORF9NT0JEU0tcIjp7XCJwcmNcIjpcIk1BUEFORFwiLFwicHJzXCI6XCJNT0JEU0tcIixcImNzdFwiOm51bGwsXCJleHBwcmRcIjoxNzIyNDYzMjAwMDAwLFwidXByXCI6W1wiUkVBREVSXCJdLFwiaXNzXCI6MTY5MDU0NjU4MDAzNCxcImV4cHRrblwiOjB9fSIsInVzciI6ImVubW9iYXBwIiwic3RsIjp0cnVlLCJsY2QiOiJ7XCJ1c3JcIjpudWxsLFwidXVpZFwiOlwiNzYzYzZkOWItZTgzMi00NjQyLTliOGQtNzQyMzI1NjljOTcxXCIsXCJjc2NcIjpcIlRFU1RTQVwiLFwib3duXCI6bnVsbCxcImNzc1wiOlwiSVRBTElBXCJ9IiwiZGlkIjpudWxsfSwianRpIjoiZDRiMjc4ZGMtNmQ0Yy00MGViLWEzYjMtNjZkNWNlOWU2MWUwIiwiaWF0IjoxNjkwNTQ2NjQ2LCJpc3MiOiJlbmF1dGgiLCJzdWIiOiI3NjNjNmQ5Yi1lODMyLTQ2NDItOWI4ZC03NDIzMjU2OWM5NzEifQ.vGwh-HSzm5-K7h8Hv21PiSci7Ko1zia-Zj3RuhxOPCUTj-P0xHgpqSOOH6gB-41JmWwSYJaJV3wGmh6u5iqenhrwRGWwDnuDdNg2vymxywlDhy41qMp7pI9J9AuknSTz2XTtVuBhuRRw1p3G6maFzV6Opt07fxDGzyga48a8ZQ4OOKFVDTyT6JsDnaaoECmtQo6C1Lh-FzjlY4CYlmViFo-6YOkafEtbnQ5FtlUOZRD6erpsLxDIX8xuQFbIx2cKCweeac8bGrKSsWqGn-ot2TMBzXdnFkI6aZJAay9iSY-P1VK4276bAk44Dx3tyzYUQWYE0Q7txSTXp6BlV4M6PA",
                                            authenticationClientId: "wid-client",
                                            authenticationGrantType: "password")

    @Published
    var visionSDKConfiguration = Configuration(visionServiceUrl: isPreview ? "mock" : "https://envisionbroker-qa.euronovate.com/v1",
                                               authenticationUrl: "https://demo.w-id.cloud/api/token",
                                               authenticationTenant: "wid",
                                               authenticationUser: "idcrecon@euronovate.com",
                                               authenticationPassword: "ruAP4eMkJceTtvAiLmeX",
                                               customizedColors: nil,
                                               customizedStrings: nil,
                                               localization: "en",
                                               logLevel: .debug,
                                               removeLogsOlderThanDays: 10,
                                               enAuthServerUrl: nil,
                                               enAuthLicenseKey: nil,
                                               enAuthJwt: "eyJhbGciOiJSUzI1NiJ9.eyJlbmMiOnsiYWRkIjp7fSwicHJkIjoie1wiRU5fTUFQX0lPU19NT0JEU0tcIjp7XCJwcmNcIjpcIk1BUElPU1wiLFwicHJzXCI6XCJNT0JEU0tcIixcImNzdFwiOm51bGwsXCJleHBwcmRcIjoxNzIyNDYzMjAwMDAwLFwidXByXCI6W1wiUkVBREVSXCJdLFwiaXNzXCI6MTY5MDU0NjU4ODA0NCxcImV4cHRrblwiOjB9LFwiRU5fTUFQX0FORF9NT0JEU0tcIjp7XCJwcmNcIjpcIk1BUEFORFwiLFwicHJzXCI6XCJNT0JEU0tcIixcImNzdFwiOm51bGwsXCJleHBwcmRcIjoxNzIyNDYzMjAwMDAwLFwidXByXCI6W1wiUkVBREVSXCJdLFwiaXNzXCI6MTY5MDU0NjU4MDAzNCxcImV4cHRrblwiOjB9fSIsInVzciI6ImVubW9iYXBwIiwic3RsIjp0cnVlLCJsY2QiOiJ7XCJ1c3JcIjpudWxsLFwidXVpZFwiOlwiNzYzYzZkOWItZTgzMi00NjQyLTliOGQtNzQyMzI1NjljOTcxXCIsXCJjc2NcIjpcIlRFU1RTQVwiLFwib3duXCI6bnVsbCxcImNzc1wiOlwiSVRBTElBXCJ9IiwiZGlkIjpudWxsfSwianRpIjoiZDRiMjc4ZGMtNmQ0Yy00MGViLWEzYjMtNjZkNWNlOWU2MWUwIiwiaWF0IjoxNjkwNTQ2NjQ2LCJpc3MiOiJlbmF1dGgiLCJzdWIiOiI3NjNjNmQ5Yi1lODMyLTQ2NDItOWI4ZC03NDIzMjU2OWM5NzEifQ.vGwh-HSzm5-K7h8Hv21PiSci7Ko1zia-Zj3RuhxOPCUTj-P0xHgpqSOOH6gB-41JmWwSYJaJV3wGmh6u5iqenhrwRGWwDnuDdNg2vymxywlDhy41qMp7pI9J9AuknSTz2XTtVuBhuRRw1p3G6maFzV6Opt07fxDGzyga48a8ZQ4OOKFVDTyT6JsDnaaoECmtQo6C1Lh-FzjlY4CYlmViFo-6YOkafEtbnQ5FtlUOZRD6erpsLxDIX8xuQFbIx2cKCweeac8bGrKSsWqGn-ot2TMBzXdnFkI6aZJAay9iSY-P1VK4276bAk44Dx3tyzYUQWYE0Q7txSTXp6BlV4M6PA",
                                               authenticationClientId: "wid-client",
                                               authenticationGrantType: "password")

    @Published
    var initKOresult: String?

    private var supportedDocuments: [OcrSupportedDocument] = []

    private var idReconDev = "https://dev.euronovate.com:58889/v2"
    private var idReconPreProd = "https://idcrecon-preprod.euronovate.com/v2"

    init() {}
    func initSDKHaya() {
        // Initialize your SDK here
        sdkInitialized = true
        // Set other states as needed
      }

    func initSDK() {
        print("ResultsView appeared with result: 1")

        Task {
            print("ResultsView appeared with result: 2")
            self.isLoading = true

            async let ocrResult = await ENMobileOCRSDK.shared.setup(usingConfiguration: ocrSDKConfiguration)
            async let visionResult = await ENMobileVisionSDK.shared.setup(usingConfiguration: visionSDKConfiguration)

            let result = await (ocrResult, visionResult)
            print("..................................................")
            print(result)
            print("..................................................")



            switch result.0 {
                case .ok:

                    switch result.1 {

                        case .ok:

                            self.supportedDocuments = await ENMobileOCRSDK.shared.getSupportedDocuments() ?? []
                            self.documentCountries = Array(Set(supportedDocuments.map {  $0.country } )).sorted()
                            self.documentTypes = Array(Set(supportedDocuments.map {  $0.type } )).sorted()
                            self.documentVersions = Array(Set(supportedDocuments.map {  $0.version } )).sorted()

                            self.sdkInitialized = true
                        print("ResultsView appeared with result: 3")

                        case .error(let message):

                            initKOresult = nil
                            DispatchQueue.main.async {
                                self.initKOresult = message
                            }

                        @unknown default: fatalError()
                    }

                case .error(let message):

                    initKOresult = nil
                    DispatchQueue.main.async {
                        self.initKOresult = message
                    }
            }

            self.isLoading = false
        }
    }

    func setIdReconDevEnv() {
        self.ocrSDKConfiguration.ocrServiceUrl = self.idReconDev
    }

    func setIdReconDevPreProd() {
        self.ocrSDKConfiguration.ocrServiceUrl = self.idReconPreProd
    }

    
    func updateDocumentType(newType: String) {
        print("updateDocumentType called with newType:", newType)

          //  self.documentType = newType
        self.haya = newType
        print("updateDocumentType called with newType:", self.haya)

      
        }

    // MARK: - Private functions
    private func resetGenricOCRDocuments() {
        print("...........resetGenricOCRDocuments............")
        self.documentCountries = Array(Set(supportedDocuments.map {  $0.country } )).sorted()
        self.documentTypes = Array(Set(supportedDocuments.map {  $0.type } )).sorted()
        self.documentVersions = Array(Set(supportedDocuments.map {  $0.version } )).sorted()
        //self.documentCountry = nil
       // self.documentType = nil
       // self.documentVersion = nil
        // Assign the current value of haya to a local variable for clarity
           let currentHaya = self.haya
           
           // Use the local variable `currentHaya` wherever you need to access the value of `haya`
           print(currentHaya)
       

        self.documentCountry = "jor"
        self.documentType = UserDefaults.standard.string(forKey: "prettyPrintedResult")
        self.documentVersion = 1
        print("*****************************************")
        print(UserDefaults.standard.string(forKey: "prettyPrintedResult"))
        print(self.documentCountry)
        print("*****************************************")

        print(self.documentType)
        print("*****************************************")

        print(self.documentVersion)
        print("*****************************************")



        /*This Funcion contains the following data*/
        /*["alb", "che", "deu", "esp", "ita", "jor", "mar", "mex", "unk"]*/
        /*["cic", "idc", "pas", "pat"]*/
        /*[1, 2, 3, 4]*/
    }
}
