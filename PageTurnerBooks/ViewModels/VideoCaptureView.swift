//
// VideoCaptureView.swift

import SwiftUI
import AVFoundation

struct VideoCaptureView: UIViewRepresentable {
    @Binding var captureSession: AVCaptureSession?
    @Binding var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var coordinator: Coordinator

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        videoPreviewLayer?.removeFromSuperlayer()
        if let videoPreviewLayer = videoPreviewLayer {
            videoPreviewLayer.frame = uiView.bounds
            uiView.layer.addSublayer(videoPreviewLayer)
        }
    }

    func makeCoordinator() -> Coordinator {
        coordinator
    }
}

