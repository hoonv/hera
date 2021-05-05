//
//  ViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyTesseract

class HomeViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var iconStackView: IconStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let imagePickerController = UIImagePickerController()
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    let viewModel = HomeViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        setupUI()
        viewModel.output.images
            .bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: HomeCollectionViewCell.self)) { idx, image, cell in
                cell.imageView.image = image
            }
            .disposed(by: bag)
        
        viewModel.output.isProccess
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { b in
                if b {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                }
            })
            .disposed(by: bag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { index in
                self.present(CouponDetailViewController(), animated: true, completion: nil)
                print(index)
                
            })
            .disposed(by: bag)
        
        super.viewDidLoad()
    }
   
    func showAuto() {
        viewModel.input.requestPhotoWithAuto()
    }
    
    func showManual() {
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentManualViewController(image: UIImage?) {
        guard let controller: ManualPhotoViewController = UIStoryboard.main.instantiate() else { return }
        controller.selectedImage = image
        self.show(controller, sender: self)
    }
    
}
 
extension String {
    func add(a: Int) {
        
    }
}
