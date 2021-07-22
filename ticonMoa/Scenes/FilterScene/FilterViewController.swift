//
//  FilterViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/22.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FilterDisplayLogic: class {
    func displaySomething(viewModel: Filter.Something.ViewModel)
}

class FilterViewController: UIViewController, FilterDisplayLogic {
    var interactor: FilterBusinessLogic?
    var router: (NSObjectProtocol & FilterRoutingLogic & FilterDataPassing)?
    
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
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        let router = FilterRouter()
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
        setupUI()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = Filter.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Filter.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        [expiredSetting, orderSetting].forEach {
            stackView.addArrangedSubview($0)
        }
        scrollView.addSubview(stackView)
        
        [scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    let expiredSetting: SettingFormView = {
        let view = SettingFormView(title: FilterOption.expired.rawValue,
                                   options: ["보이기", "숨기기"])
        return view
    }()
    
    let orderSetting: SettingFormView = {
        let view = SettingFormView(title: FilterOption.order.rawValue,
                                   options: ["등록순", "남은기간순"])
        return view
    }()
}
