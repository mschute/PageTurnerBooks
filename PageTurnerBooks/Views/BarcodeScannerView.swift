import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @Binding var isShowingScanner: Bool
    var coordinator: Coordinator

    init(isShowingScanner: Binding<Bool>, coordinator: Coordinator) {
        self._isShowingScanner = isShowingScanner
        self.coordinator = coordinator
        coordinator.onBookRetrieved = {
            DispatchQueue.main.async {
                isShowingScanner.wrappedValue = false // Ensure UI updates happen on the main thread
            }
        }
    }

    var body: some View {
        ZStack {
            VideoCaptureView(captureSession: .constant(coordinator.captureSession!),
                             videoPreviewLayer: .constant(coordinator.videoPreviewLayer!),
                             coordinator: coordinator)
                .edgesIgnoringSafeArea(.all)
            BarcodeOverlay(captureSession: .constant(coordinator.captureSession!))
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear(perform: coordinator.startSession)
        .onDisappear {
            coordinator.captureSession?.stopRunning()
            isShowingScanner = false
        }
    }
}
