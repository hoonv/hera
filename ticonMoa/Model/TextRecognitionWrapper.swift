//
//  TextRecognitionWrapper.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import Vision

class TextRecognitionWrapper {
    
    let completion: ((UIImage) -> Void)
    let image: UIImage
    let layer: CALayer
    
    lazy var textRecogRequest: VNRecognizeTextRequest = {
        let textDetectRequest = VNRecognizeTextRequest {
            [weak self] r,e  in
            self?.handleDetectedText(request: r, error: e) }
        // Tell Vision to report bounding box around each character.
//        textDetectRequest.reportCharacterBoxes = true
        return textDetectRequest
    }()
    
    init(image: UIImage, layer: CALayer, completion: @escaping ((UIImage) -> Void)) {
        self.image = image
        self.layer = layer
        self.completion = completion
    }
    
    func perform() {
        guard let ciImage = CIImage(image: image) else { return }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])

        do {
            try handler.perform([self.textRecogRequest])
        } catch {
            print("Error Decoding Barcode")
        }
    }
    
    fileprivate func handleDetectedText(request: VNRequest?, error: Error?) {
        if let _ = error as NSError? {
            return
        }
        
        guard let results = request?.results as? [VNRecognizedTextObservation] else { return }
        
        print("\n\n\n\n")
        for wordObservation in results {
            let wordBox = boundingBox(forRegionOfInterest: wordObservation.boundingBox, withinImageBounds: layer.bounds)
            let wordLayer = shapeLayer(color: .red, frame: wordBox)
            layer.addSublayer(wordLayer)
            print(wordObservation.topCandidates(1).compactMap { $0.string })
//            guard let charBoxes = wordObservation.characterBoxes else {
//                continue
//            }
//            for charObservation in charBoxes {
//                let charBox = boundingBox(forRegionOfInterest: charObservation.boundingBox, withinImageBounds: layer.bounds)
//                print(charObservation.boundingBox, layer.bounds, charBox)
//                let charLayer = shapeLayer(color: .purple, frame: charBox)
//                charLayer.borderWidth = 1
//
//                // Add to pathLayer on top of image.
//                layer.addSublayer(charLayer)
//            }
        }
    }
    
    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        // Create a new layer.
        let layer = CAShapeLayer()
        
        // Configure layer's appearance.
        layer.fillColor = nil // No fill to show boxed object
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 2
        
        // Vary the line color according to input.
        layer.borderColor = color.cgColor
        
        // Locate the layer.
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        // Transform the layer to have same coordinate system as the imageView underneath it.
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        return layer
    }
    
    
    fileprivate func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        // Begin with input rect.
        var rect = forRegionOfInterest
        
        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
}
