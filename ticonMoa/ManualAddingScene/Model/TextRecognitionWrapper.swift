//
//  TextRecognitionWrapper.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import Vision

class TextRecognitionWrapper {
    
    let completion: (([(UIImage, String)]) -> Void)
    let image: UIImage
    let layer: CALayer
    
    lazy var textRecogRequest: VNRecognizeTextRequest = {
        let textDetectRequest = VNRecognizeTextRequest {
            [weak self] r,e  in
            self?.handleDetectedText(request: r, error: e) }
        return textDetectRequest
    }()
    
    init(image: UIImage, layer: CALayer, completion: @escaping (([(UIImage, String)]) -> Void)) {
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
        
        let mapped = results.compactMap { result -> (UIImage, String)? in
            guard let payload = result.topCandidates(1).first?.string else { return nil }
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: image.size.width, y: -image.size.height)
            transform = transform.translatedBy(x: 0, y: -1)
            let rect = result.boundingBox.applying(transform)
            
            guard let cropped = image.crop(rect: rect) else { return nil }
            return (cropped, payload)
        }
        
        print(mapped.count)
        completion(mapped)
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

extension UIImage {
    func crop( rect: CGRect) -> UIImage? {
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale

        guard let imageRef = self.cgImage?.cropping(to: rect) else{ return nil }
        let image = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
}
