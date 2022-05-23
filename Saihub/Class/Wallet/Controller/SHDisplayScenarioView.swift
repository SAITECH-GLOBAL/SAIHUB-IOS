//
//  SHDisplayScenarioView.swift
//  Saihub
//
//  Created by 周松 on 2022/2/17.
//

import SwiftUI
import URKit
import URUI
import LifeHash

protocol Preference { }

struct SHDisplayScenarioView: View {
    
    var scenario: String
    var maxFragmentLen: Int

    @StateObject private var displayState: URDisplayState
    @StateObject private var lifeHashState: LifeHashState

    @Environment(\.horizontalSizeClass) var sizeClass
    
    init(scenario: String, maxFragmentLen: Int, signTransactionBlock: @escaping (() -> Void)) {
        self.scenario = scenario
        self.maxFragmentLen = maxFragmentLen
        self.scanSignTransactionBlock = signTransactionBlock
        
//        let ur = makeBytesUR(scenario.utf8Data)
        let ur = try!UR(urString: scenario)
        self._displayState = StateObject(wrappedValue: URDisplayState(ur: ur, maxFragmentLen: maxFragmentLen))
        self._lifeHashState = StateObject(wrappedValue: LifeHashState(input: ur.cbor))
        
    }
    
    var scanSignTransactionBlock = {

    }
    
    @State var columnWidth: CGFloat?
    
    @Environment(\.presentationMode) var presentation

    var body: some View {
        
        let screenW = UIScreen.main.bounds.size.width
        
        let scale = screenW / 375
        
        let qrCodeWidth = 241 * scale
                
        ZStack {
            VStack(alignment: .center, spacing: 0) {

                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()

                    }) {
                        Image("baseController_blackBack")
                    }
                    .padding()
                    .frame(width: 30, height: 30, alignment: .center)
                    Spacer()
                                    
                }
                            
                Text(GCLocalizedString_swift(key: "multi_sign_tip"))
                    .foregroundColor(Color.black).padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0))
                    .font(Font.custom("Montserrat-Regular", size: 14))

                URQRCode(data: .constant(displayState.part))
                    .frame(width: qrCodeWidth)
                    .padding(24)
                    .background(Color(hex: "#F6F8FA"))
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))
                                
                Button {
                    self.scanSignTransactionBlock()
                } label: {
                    Text(GCLocalizedString_swift(key: "scan_signed"))
                        .frame(width: 335 * scale, height: 52 * scale, alignment: .center)

                }
                .background(LinearGradient(colors: [Color(hex: "#005F6F"),Color(hex: "#48ADC3")], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(Color.white)
                .cornerRadius(26 * scale)
                .font(Font.custom("Montserrat-Medium", size: 14))

                Spacer()
                
            }
            .frame(width: screenW - 40 * scale)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear {
                displayState.run()
            }
            .onDisappear {
                displayState.stop()
            }
            .onPreferenceChange(columnWidthKey) { prefs in
                let minPref = prefs.reduce(CGFloat.infinity, min)
                if minPref > 0 {
                    columnWidth = minPref
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(GCLocalizedString_swift(key: "Send"))
                    .font(Font.custom("Montserrat-Regular", size: 14))
                Spacer()
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            
        }
        
    }

    struct AppendValue<T: Preference>: PreferenceKey {
        static var defaultValue: [CGFloat] { [] }
        static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
            value.append(contentsOf: nextValue())
        }
    }

    enum ColumnWidth: Preference { }
    let columnWidthKey = AppendValue<ColumnWidth>.self

}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

