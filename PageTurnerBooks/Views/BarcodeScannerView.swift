import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @Binding var isShowingScanner: Bool // Use the binding to control the view's visibility
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var coordinator: Coordinator

    init(isShowingScanner: Binding<Bool>, coordinator: Coordinator) {
        self._isShowingScanner = isShowingScanner
        self.coordinator = coordinator
    }

    var body: some View {
        ZStack {
            VideoCaptureView(captureSession: .constant(captureSession),
                             videoPreviewLayer: .constant(videoPreviewLayer),
                             coordinator: coordinator)
                .edgesIgnoringSafeArea(.all)
            BarcodeOverlay(captureSession: .constant(captureSession))
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear(perform: startSession)
        .onDisappear {
            self.captureSession.stopRunning()
            self.isShowingScanner = false // Ensure the scanner view is closed when the component disappears
        }
    }
    
    private func startSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)

            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)

            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
            metadataOutput.setMetadataObjectsDelegate(coordinator, queue: DispatchQueue.main)

            videoPreviewLayer.session = captureSession
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = UIScreen.main.bounds

            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
            print("Session is running")
        } catch {
            print("Error starting the camera: \(error)")
        }
    }
}
