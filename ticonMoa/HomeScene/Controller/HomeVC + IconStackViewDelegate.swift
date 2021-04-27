//
//  HomeVC + IconStackViewDelegate.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit

extension HomeViewController: IconStackViewDelegate {
    func iconStackView(_ iconStackView: IconStackView, didSelected index: Int) {

        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
        let autoAction = UIAlertAction(title: "auto", style: .default) {_ in
            self.showAuto()
        }
        let manualAction = UIAlertAction(title: "manual", style: .default) {_ in
            self.showManual()
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        optionMenu.addAction(autoAction)
        optionMenu.addAction(manualAction)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showAuto() {
//        indicator.startAnimating()
        viewModel.input.requestPhotoWithAuto()
    }
    
    func showManual() {
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
}
