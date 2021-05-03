//
//  ViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        super.viewDidLoad()
    }
    
    private func setupUI() {
        self.view.layer.cornerRadius = 30
        self.iconStackView.delegate = self

        self.collectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.collectionView.layer.cornerRadius = 30
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let panRight = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(panRight)

        indicator.centerInSuperview()
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = translate.x / gesture.view!.bounds.size.width
        
        if gesture.state == .began {
            let controller = storyboard!.instantiateViewController(withIdentifier: "PhotoAddViewController") as! MapViewController
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (self.view.frame.width - 20) / 3
        return CGSize(width: w, height: w)
    }
}
