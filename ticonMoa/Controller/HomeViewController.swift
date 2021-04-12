//
//  ViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//

import UIKit
import Photos
import Vision

class HomeViewController: UIViewController {
    
    @IBOutlet weak var iconStackView: IconStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        setupUI()
        let panRight = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(panRight)

        super.viewDidLoad()
    }

    private func setupUI() {
        self.view.layer.cornerRadius = 30
        self.collectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.collectionView.layer.cornerRadius = 30
        self.iconStackView.delegate = self
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = translate.x / gesture.view!.bounds.size.width
        
        if gesture.state == .began {
            let controller = storyboard!.instantiateViewController(withIdentifier: "PhotoAddViewController") as! PhotoAddViewController
            interactionController = UIPercentDrivenInteractiveTransition()
            controller.customTransitionDelegate.interactionController = interactionController

            show(controller, sender: self)
        } else if gesture.state == .changed {
            interactionController?.update(percent * 0.8)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            let velocity = gesture.velocity(in: gesture.view)
            if (percent > 0.5 && velocity.x == 0) || velocity.x > 100 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
    
    let imagePickerController = UIImagePickerController()
    
    func showManual() {
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)

    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = images[indexPath.row]
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (self.view.frame.width - 20) / 3
        return CGSize(width: w, height: w)
    }
}

extension HomeViewController: IconStackViewDelegate {
    func iconStackView(_ iconStackView: IconStackView, didSelected index: Int) {
//        let controller = storyboard!.instantiateViewController(withIdentifier: "PhotoAddViewController") as! PhotoAddViewController
//        show(controller, sender: self)
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
        // 2
        let autoAction = UIAlertAction(title: "auto", style: .default) {_ in
            print("auto")
        }
        let manualAction = UIAlertAction(title: "manual", style: .default) {_ in
            self.showManual()
        }
            
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        // 4
        optionMenu.addAction(autoAction)
        optionMenu.addAction(manualAction)
        optionMenu.addAction(cancelAction)
            
        // 5
        self.present(optionMenu, animated: true, completion: nil)

    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideInAnimator(transitionType: .dismissing)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideInAnimator(transitionType: .presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}

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
    
    func presentManualViewController(image: UIImage?) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManualPhotoViewController") as! ManualPhotoViewController
        controller.selectedImage = image
        self.show(controller, sender: self)
    }
}
