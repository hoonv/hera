//
//  HomeViewController2.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addView: ButtonAddView!
    
    let imagePickerController = UIImagePickerController()

    var pullUpVC: PullUpViewController?
    let viewModel = HomeViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "HomeCollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell2")
        collectionView.register(UINib(nibName: "HomeCategoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCategoryHeaderView")
        
        addView.addButton.rx.tap
            .bind { [weak self] in
                self?.pullUpView()
            }.disposed(by: bag)
        addView.addButton.rx.controlEvent(.touchDown)
            .bind { [weak self] in
                self?.addView.addButton.shrink()
            }.disposed(by: bag)
        addView.addButton.rx.controlEvent(.touchUpInside)
            .bind { [weak self] in
                self?.addView.addButton.expand()
            }.disposed(by: bag)
        addView.addButton.rx.controlEvent(.touchUpOutside)
            .bind { [weak self] in
                self?.addView.addButton.expand()
            }.disposed(by: bag)
    }
    
    func pullUpView() {
        guard self.pullUpVC == nil else { return }
        guard let pullUpVC: PullUpViewController = storyboard?.instantiateViewController(withIdentifier: PullUpViewController.identifier) as? PullUpViewController else { return }
        self.addChild(pullUpVC)
        pullUpVC.dismissClosure = dismissPullUpView
        pullUpVC.view.frame = view.bounds
        self.view.addSubview(pullUpVC.view)
        pullUpVC.didMove(toParent: self)
        self.pullUpVC = pullUpVC
    }
    
    func dismissPullUpView(state: PullUpFinishState) {
        self.pullUpVC?.willMove(toParent: nil)
        self.pullUpVC?.view.removeFromSuperview()
        self.pullUpVC?.removeFromParent()
        self.pullUpVC?.dismiss(animated: false, completion: nil)
        self.pullUpVC = nil
        if state == .auto {
            print("auto")
        } else if state == .manaul  {
            showManual()
        }
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

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 50) / 2, height: 220)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell2", for: indexPath) as? HomeCollectionViewCell2 else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 12
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 64)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCategoryHeaderView", for: indexPath) as? HomeCategoryHeaderView else { return UICollectionReusableView() }
        return header
    }
}


extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
