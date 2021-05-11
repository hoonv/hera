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
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        bind()
    }
    
    func bind() {
    
        viewModel.output.images
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { images in
                self.images = images
                self.collectionView.reloadData()
            })
            .disposed(by: bag)

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
            showAuto()
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
