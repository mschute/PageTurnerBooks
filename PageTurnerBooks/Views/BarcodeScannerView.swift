//
// BarcodeScannerView.swift

import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @Binding var isShowingScanner: Bool
    var coordinator: Coordinator

    var body: some View {
        NavigationView {
            ZStack {
                VideoCaptureView(captureSession: .constant(coordinator.captureSession!),
                                 videoPreviewLayer: .constant(coordinator.videoPreviewLayer!),
                                 coordinator: coordinator)
                    .edgesIgnoringSafeArea(.all)
                BarcodeOverlay(captureSession: .constant(coordinator.captureSession!))
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle("Scan Barcode", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                isShowingScanner = false
                coordinator.captureSession?.stopRunning()
            })
            .onAppear(perform: coordinator.startSession)
        }
        .tint(.pTPrimary)
    }
}
