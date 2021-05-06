//
//  LoginController.swift
//  ticonMoa
//
//  Created by ychoib on 2021/05/03.
//

import UIKit
import Firebase
import GoogleSignIn //for google login
import AuthenticationServices //for apple login
import CryptoKit
import FirebaseDatabase

class LoginViewController: UIViewController,  GIDSignInDelegate {
    
    
    @IBOutlet weak var appleSignInView: UIView!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!

    @IBOutlet weak var googleSignOutButton: UIButton!
    
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    //database
    var ref = Database.database().reference()
    //로그인 기능
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        if #available(iOS 13.2, *) {
            print(0)
            setupLoginWithAppleButton()
        } else {
            print(1)
            signInWithAppleButtonPressed()
        }
    }
//    애플 로그인
    fileprivate var currentNonce: String?
    @available(iOS 13.2, *)
    private func setupLoginWithAppleButton() {
        let appleSignInButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        appleSignInButton.layer.frame = CGRect(x : 0, y : 0, width: googleSignInButton.layer.preferredFrameSize().width - 40, height: googleSignInButton.layer.preferredFrameSize().height)
        appleSignInButton.cornerRadius = 5
        appleSignInButton.addTarget(self, action: #selector(signInWithAppleButtonPressed), for: .touchUpInside)
        appleSignInView.addSubview(appleSignInButton)
    }
    @available(iOS 13, *)
    @objc private func signInWithAppleButtonPressed() {
        print("applelogin")
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        startSignInWithAppleFlow()
    }
    
    
    
//구글 로그인
    //자동 로그인
    /*
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            guard let MainPage = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as? UITabBarController else {
                return
            }
            MainPage.modalPresentationStyle = .fullScreen
            self.present(MainPage, animated: true, completion: nil)
        }
    }
    */
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
        if let error = error {
            return
        }
        
        guard let auth = user.authentication else { return }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                tabbarVC.modalPresentationStyle = .fullScreen
                self.present(tabbarVC, animated: true, completion: nil)
                let email = Auth.auth().currentUser?.email
                let uid = Auth.auth().currentUser?.uid
                let user_id = email?.components(separatedBy: "@")[0]
                let post = [ "uid" :uid, "email":email,"Coupon" : ""]
                let childupdates = ["/User/\(user_id!)": post]
                self.ref.updateChildValues(childupdates)
                /*
                self.ref.child("User").updateChildValues([user_id!:""])
                self.ref.child("User").child(user_id!).updateChildValues(["email":email!])
                self.ref.child("User").child(user_id!).updateChildValues(["uid":uid!])
                self.ref.child("User").child(user_id!).child("Coupon")
                */
            }
        }
    }
                
    @IBAction func didTapSignOut(sender: AnyObject) {
         do {
            try Auth.auth().signOut()
           
         } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
         }
        self.dismiss(animated: true, completion: nil)
    }

}


@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken
            else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8)
            else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            } // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in if (error != nil) {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabbarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                    tabbarVC.modalPresentationStyle = .fullScreen
                    self.present(tabbarVC, animated: true, completion: nil)

                }
                print(error!.localizedDescription)
                return
            } // User is signed in to Firebase with Apple.
                // ...
            let email = Auth.auth().currentUser?.email
            let uid = Auth.auth().currentUser?.uid
            let user_id = email?.components(separatedBy: "@")[0]
            let post = [ "uid" :uid, "email":email,"Coupon" : ""]
            let childupdates = ["/User/\(user_id!)": post]
            self.ref.updateChildValues(childupdates)
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

    // fierbase iOS 로그인 가이드
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map {_ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

