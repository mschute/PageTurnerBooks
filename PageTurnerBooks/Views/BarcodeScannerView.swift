//
// BarcodeScannerView.swift

import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @Binding var isShowingScanner: Bool
    var coordinator: Coordinator
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .padding(.leading, 15)
                            .padding(.bottom, 6)
                    }
                    
                    Text("Barcode Scanner")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 3)
                        .padding(.bottom, 10)
                    
                    Spacer()
                        .frame(maxWidth: 35)
                }
                .background(Color.pTPrimary)
                .ignoresSafeArea(edges: .horizontal)
                .ignoresSafeArea(edges: .bottom)

                
                
                ZStack {
                    VideoCaptureView(captureSession: .constant(coordinator.captureSession!),
                                     videoPreviewLayer: .constant(coordinator.videoPreviewLayer!),
                                     coordinator: coordinator)
                    .edgesIgnoringSafeArea(.all)
                    BarcodeOverlay(captureSession: .constant(coordinator.captureSession!))
                        .edgesIgnoringSafeArea(.all)
                }
                
                
                
//                .navigationBarTitle("Scan Barcode", displayMode: .inline)
//                .navigationBarItems(leading: Button("Back") {
//                    isShowingScanner = false
//                    coordinator.captureSession?.stopRunning()
//                })
//                .onAppear(perform: coordinator.startSession)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .tint(.pTPrimary)
    }
}
