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

protocol CouponListDisplayLogic: class {
    func displaySomething(viewModel: CouponList.Something.ViewModel)
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
        doSomething()
        setupCollectionView()
        setupUI()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = CouponList.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: CouponList.Something.ViewModel) {
        //nameTextField.text = viewModel.name
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
    
    var addButton: CouponAddButton = {
        let button = CouponAddButton()
        return button
    }()
}

extension CouponListViewController {
     
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [collectionView, header, addButton].forEach {
            view.addSubview($0)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48)
            make.trailing.equalToSuperview().offset(-48)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(56)
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
}

extension CouponListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cellName: String { "CouponListCell" }
    
    func setupCollectionView() {
        collectionView.register(CouponListCell.self, forCellWithReuseIdentifier: cellName)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? CouponListCell else {
            return CouponListCell()
        }
        return cell
    }
}

extension CouponListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 150)
    }
}
