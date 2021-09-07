//
//  CouponListViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright (c) 2021  . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SnapKit

protocol CouponListDisplayLogic: AnyObject {
    func displayCouponList(viewModel: CouponList.FetchCoupon.ViewModel)
}

class CouponListViewController: UIViewController, CouponListDisplayLogic {

    
    var interactor: CouponListBusinessLogic?
    var router: (NSObjectProtocol & CouponListRoutingLogic & CouponListDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CouponListInteractor()
        let presenter = CouponListPresenter()
        let router = CouponListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoupons()
        setupCollectionView()
        setupUI()
    }
    
    // MARK: fetch Coupons
    var coupons: [ViewModelCoupon] = []
    var sectionNames: [String] = []
    
    func fetchCoupons() {
        let request = CouponList.FetchCoupon.Request()
        interactor?.fetchCoupons(request: request)
    }
    
    func displayCouponList(viewModel: CouponList.FetchCoupon.ViewModel) {
        self.coupons = viewModel.coupons
        self.sectionNames = viewModel.sectionName
        collectionView.reloadData()
    }
    
    // MARK: View
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()

    var header: CouponListHeader = {
        let header = CouponListHeader()
        return header
    }()
    
    // MARK: Scroll Animation
    
    var currentOffset: CGFloat = 0
}


// MARK: setupUI

extension CouponListViewController {
    
    func setupUI() {
        let pinterest = PinterestLayout()
        pinterest.delegate = self
        collectionView.collectionViewLayout = pinterest
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(newCoupon), name: .couponListChanged, object: nil)
        header.addIcon.addTarget(self, action: #selector(addIconTouched), for: .touchUpInside)
        header.filterIcon.addTarget(self, action: #selector(filterIconTouched), for: .touchUpInside)
        [collectionView, header].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(43)
            make.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func newCoupon() {
        self.fetchCoupons()
    }
    
    @objc func addIconTouched() {
        router?.routeToCouponAdd()
    }
    
    @objc func filterIconTouched() {
        router?.routeToFilter()
    }
}

// MARK: CollectionView

extension CouponListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cellId: String { "CouponListCell" }
    var headerID: String { "CouponListSectionCell" }

    func setupCollectionView() {
        collectionView.isSpringLoaded = true
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewCouponListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CouponListSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? NewCouponListCell else {
            return NewCouponListCell()
        }
        let coupon = coupons[indexPath.row]
        cell.configure(viewModel: coupon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = coupons[indexPath.row]
        router?.routeToCouponDetail(image: data.image,barcode: data.barcode, id: data.id)
    }
    
    
}

extension CouponListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let size = coupons[indexPath.row].image?.size else {
            return 0
        }
        let ratio = size.height / size.width
        let m = min(collectionView.frame.height / 2.5, ratio * (collectionView.frame.width - 2) / 2)
        return m
    }
}

