//
//  SHScanView.swift
//  Saihub
//
//  Created by 周松 on 2022/2/16.
//

import SwiftUI
import URKit
import URUI
import LifeHash
import PhotosUI

struct SHScanView: View {
    
    @StateObject var scanState = URScanState()
    @State private var estimatedPercentComplete = 0.0
    @State private var fragmentStates = [URFragmentBar.FragmentState]()
    @State private var canRestart = true
    @State private var result: URScanResult?
    @State private var startDate: Date?
    
    @State private var isPresented: Bool = false
    @State var pickerResult: String = ""

    var config: PHPickerConfiguration {
            var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.filter = .images
            config.selectionLimit = 0
            return config
           }
    
    @Environment(\.presentationMode) var presentation
    
    var scanResult: ((String) -> Void)
        
    func restart() {
        result = nil
        startDate = nil
        estimatedPercentComplete = 0
        fragmentStates = [.off]
        scanState.restart()
    }
    
    var body: some View {
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
                
        let scaleY = 0.31 * screenH

        ZStack {
                URVideo(scanState: scanState)

                BlurView(style: .dark)

                Button {
                    self.isPresented = true
                } label: {
                    Image("scan_openPhoto")
                }.sheet(isPresented: $isPresented) {

                } content: {
                    SHPhotoPicker(configuration: self.config, isPresented: $isPresented, pickerResult: $pickerResult) { value in
                        
                        DispatchQueue.main.async {
                            self.scanResult(value)
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                }.frame(width: 52, height: 52, alignment: .center)
                .background(Color.white.opacity(0.2))
                    .cornerRadius(26)
                    .offset(x: 0, y: scaleY)
                
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                    
                }) {
                    Image("baseController_whiteBack")
                }
                .padding()
                .frame(width: 30, height: 30, alignment: .center)
                    .offset(x: -(screenW / 2 - 12 - 20) , y: -(screenH / 2 - 12 - 19 - 20))
                    
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .accentColor(.orange)
            .onReceive(scanState.resultPublisher) { result in
                switch result {
                case .ur (let ur):
                    estimatedPercentComplete = 1
                    fragmentStates = [.highlighted]
                    self.result = result
                    
                    self.scanResult(ur.string)
                    
                    self.presentation.wrappedValue.dismiss()

                case .other (let otherStr):
                    estimatedPercentComplete = 1
                    fragmentStates = [.highlighted]
                    self.result = result
                    
                    self.scanResult(otherStr)
                    
                    self.presentation.wrappedValue.dismiss()

                case .progress(let p):

                    estimatedPercentComplete = p.estimatedPercentComplete
                    fragmentStates = p.fragmentStates
                    if startDate == nil {
                        startDate = Date()
                    }

                case .failure(let error):
                    print("🛑 failure: \(error)")
                    self.result = result
                    canRestart = false
                    
                    self.scanResult("")
                    self.presentation.wrappedValue.dismiss()

                case .reject:
                    self.scanResult("")
                    self.presentation.wrappedValue.dismiss()
                    print("reject")
                }
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .statusBar(hidden: true)

    }
    
    func HoleShapeMask(in rect: CGRect) -> some View {
        var shape = Rectangle().path(in: rect)
        shape.addPath(Rectangle().path(in: CGRect(x: 0, y: 0, width: 241, height: 241)))
        return shape.fill(style: FillStyle(eoFill: true))
    }

}

/// 毛玻璃
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
        
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        let rect = UIScreen.main.bounds
        let scale = rect.size.width / 375
        // 中间透明框宽度
        let width = 241 * scale
        
        let lineW: Double = 34
        let lineH: Double = 4
        
        let x = (rect.size.width - width) / 2
        let y = 0.35 * rect.size.height
        
        // 左上角view
        let leftTopLine = UIView(frame: CGRect(x: x, y: y, width: lineW, height: lineH))
        leftTopLine.backgroundColor = .white
        view.addSubview(leftTopLine)
        
        let topLeftLine = UIView(frame: CGRect(x: x, y: y, width: lineH, height: lineW))
        topLeftLine.backgroundColor = .white
        view.addSubview(topLeftLine)
        
        // 右上角
        let rightTopLine = UIView(frame: CGRect(x: x + width - lineH, y: y, width: lineH, height: lineW))
        rightTopLine.backgroundColor = .white
        view.addSubview(rightTopLine)
        
        let topRightLine = UIView(frame: CGRect(x: x + width - lineW, y: y, width: lineW, height: lineH))
        topRightLine.backgroundColor = .white
        view.addSubview(topRightLine)
        
        // 左下角
        let leftBottomLine = UIView(frame: CGRect(x: x, y: y + width - lineW, width: lineH, height: lineW))
        leftBottomLine.backgroundColor = .white
        view.addSubview(leftBottomLine)

        let bottomLeftLine = UIView(frame: CGRect(x: x, y: y + width - lineH, width: lineW, height: lineH))
        bottomLeftLine.backgroundColor = .white
        view.addSubview(bottomLeftLine)
        
        // 右下角
        let rightBottomLine = UIView(frame: CGRect(x: x + width - lineH, y: y + width - lineW, width: lineH, height: lineW))
        rightBottomLine.backgroundColor = .white
        view.addSubview(rightBottomLine)
        
        let bottomRightLine = UIView(frame: CGRect(x: x + width - lineW, y: y + width - lineH, width: lineW, height: lineH))
        bottomRightLine.backgroundColor = .white
        view.addSubview(bottomRightLine)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let clipPath = UIBezierPath(rect: UIScreen.main.bounds)

        let rect = UIScreen.main.bounds
          
        let scale = rect.size.width / 375
          
        let width = 241 * scale
          
        let x = (rect.size.width - width) / 2

        let effetView = uiView.subviews[0]
        
        // 绘制中间镂空
        let circlePath = UIBezierPath(roundedRect:CGRect(x: x, y: 0.35 * rect.size.height , width: width, height: width) , cornerRadius: 0 )
        
        clipPath.append(circlePath)

        let layer = CAShapeLayer()
        layer.path = clipPath.cgPath
        layer.fillRule = .evenOdd
        effetView.layer.mask = layer
        effetView.layer.masksToBounds = true

    }
}

/// 照片选择
struct SHPhotoPicker: UIViewControllerRepresentable {
    
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    @Binding var pickerResult: String
    
    /// 二维码解码回调
    var qrCodeDecodeResult: ((String) -> Void)

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: SHPhotoPicker
        
        init(_ parent: SHPhotoPicker) {
            self.parent = parent
        }
        
        /// 选择完照片的回调
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            var qrCode: String = ""
            if results.isEmpty == false {
                let resultImage = results.first!
                
                if resultImage.itemProvider.canLoadObject(ofClass: UIImage.self) {

                    resultImage.itemProvider.loadObject(ofClass: UIImage.self) {
                        (newImage, error) in

                        if let error = error {
                            print(error.localizedDescription)
                        } else if let image = newImage as? UIImage {
                            
                            // 二维码解析器
                            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
                            let features = detector?.features(in: CIImage(image: image)!)
                            
                            if features?.isEmpty == false {
                                let item = features?.last as! CIQRCodeFeature
                                qrCode = item.messageString ?? ""
                                
                            }
                        }
                        
                        self.parent.qrCodeDecodeResult(qrCode)
                    }
                } else {
                    print("Loaded Asset is not a Image")
                }
            }
            parent.isPresented = false
        }
    }

}




