//
//  MachineLearning.swift
//  CardScanThreads
//
//  Created by Sam King on 2/12/24.
//

import CardScan
import UIKit

class MachineLearning: ObservableObject {
    @Published var appleOcrResult = "Not run"
    @Published var ddOcrResult = "Not run"
    @Published var finalResult = "Not run"
    
    func extractCreditCardNumber() async {
        guard let image = UIImage(named: "sams_bofa").flatMap({ self.crop(image: $0) }) else {
            print("Image not found")
            return
        }
        
        let startTime = Date()
        async let appleOptional = self.appleOcr(croppedImage: image)
        async let ddOptional = self.ddOcr(croppedImage: image)
        let apple = await appleOptional
        let dd = await ddOptional
        print("ML Time: \(Date().timeIntervalSince(startTime))")
        
        Task { @MainActor in
            self.appleOcrResult = apple ?? "Not found"
            self.ddOcrResult = dd ?? "Not found"
            self.finalResult = dd ?? apple ?? "Not found"
        }
    }
}

extension MachineLearning {
    func crop(image: UIImage) -> CGImage? {
        let x = 0.0
        let width = Double(image.size.width)
        let height = width * 375.0 / 600.0
        let y = Double(image.size.height) * 0.5 - height * 0.5
        let rect = CGRect(x: x, y: y, width: width, height: height)
        return image.cgImage?.cropping(to: rect)
    }
    
    func appleOcr(croppedImage: CGImage) async -> String? {
        let appleOcr = CardScan.AppleCreditCardOcr(dispatchQueueLabel: "apple ocr")
        let result = appleOcr.recognizeCard(in: croppedImage, roiRectangle: CGRect(x: 0, y: 0, width: croppedImage.width, height: croppedImage.height))
        try? await Task.sleep(for: .seconds(5))
        return result.number
    }
    
    func ddOcr(croppedImage: CGImage) async -> String? {
        let ddOcr = CardScan.SSDCreditCardOcr(dispatchQueueLabel: "dd ocr")
        let result = ddOcr.recognizeCard(in: croppedImage, roiRectangle: CGRect(x: 0, y: 0, width: croppedImage.width, height: croppedImage.height))
        try? await Task.sleep(for: .seconds(3))
        return result.number
    }
}
