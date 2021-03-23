//
//  ViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//  Modify login/join by 황혜원 on 2021/03/23
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btn_join: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    
    let myStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //join btn
    @IBAction func onClick_join(_ sender: Any) {
        let joinController = myStoryBoard.instantiateViewController(withIdentifier: "joinVC")
        self.show(joinController, sender: self)
    }
    
    //login bth
    @IBAction func onClick_login(_ sender: Any) {
        let loginController = myStoryBoard.instantiateViewController(withIdentifier: "loginVC")
        self.show(loginController, sender: self)
    }
}

