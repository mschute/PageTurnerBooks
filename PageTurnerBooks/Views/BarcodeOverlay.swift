//
//  BarcodeOverlay.swift

import SwiftUI
import AVFoundation

struct BarcodeOverlay: View {
    @Binding var captureSession: AVCaptureSession?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .overlay(
                    Text("Scan Barcode Here")
                        .foregroundColor(.white)
                        .font(.title)
                )
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .onTapGesture {
                self.captureSession?.startRunning()
            }
            .onAppear {
                self.captureSession?.stopRunning()
            }
        }
    }
}
