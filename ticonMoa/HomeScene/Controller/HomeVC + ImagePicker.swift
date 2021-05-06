//
//  HomeVC + d.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit

extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var pickedImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickedImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        picker.dismiss(animated: true) {
            self.presentManualViewController(image: pickedImage)
        }

    }
}
