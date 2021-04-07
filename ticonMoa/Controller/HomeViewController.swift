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
    
    private let photoManager = PhotoManager()
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
        photoManager.delegate = self
        photoManager.requestAuthAndGetAllPhotos()
        
        super.viewDidLoad()
    }

    private func setupUI() {
        self.view.layer.cornerRadius = 30
//        self.collectionView.layer.cornerRadius = 30
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
        let controller = storyboard!.instantiateViewController(withIdentifier: "PhotoAddViewController") as! PhotoAddViewController
        show(controller, sender: self)
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

extension HomeViewController: PhotoManagerDelegate {
    func photoManager(_ photoManager: PhotoManager, didLoad image: UIImage?, index: Int) {
        guard let image = image else { return }
        let bw = BarcodeRequestWrapper(image: image) { _ in
            self.images.append(image)
        }
        bw.requestDetect()
    }
}
