//
//  ProfileViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/28.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displaySomething(viewModel: Profile.Something.ViewModel)
}

class ProfileViewController: UIViewController, ProfileDisplayLogic {
    var interactor: ProfileBusinessLogic?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
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
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
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
        setupUI()
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = Profile.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Profile.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        return view
    }()
    
    var settings: [String] = ["유효기간 하루 전 알림", "유효기간 7일전 알 림"]
}

extension ProfileViewController {
    func setupUI() {
        // 프로필 이미지, 이름
        // 사용완료 쿠폰 -> Navigation
        // 유효기간 (당일 7일)알림 toggle
        self.view.backgroundColor = .systemBackground
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        [tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    var cellID: String { "ProfileCell" }
    func setupTableView() {
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ProfileCell else { return ProfileCell() }
        let switchView = UISwitch(frame: .zero)
        cell.accessoryView = switchView
        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }
}
