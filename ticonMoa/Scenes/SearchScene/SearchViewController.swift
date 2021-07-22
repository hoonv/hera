//
//  SearchViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/31.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
}
//
//extension SearchViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.view.endEditing(true)
//        searchBar.showsCancelButton = false
//        UIView.animate(withDuration: 0.2, animations: {
//             self.searchBar.layoutIfNeeded()
//             }, completion: {finished in
//                 print("Animation finished")
//         })
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.view.endEditing(true)
//        searchBar.showsCancelButton = false
//        UIView.animate(withDuration: 0.2, animations: {
//             self.searchBar.layoutIfNeeded()
//             }, completion: {finished in
//                 print("Animation finished")
//         })
//
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("begin ended")
//        searchBar.showsCancelButton = true
//        UIView.animate(withDuration: 0.2, animations: {
//             self.searchBar.layoutIfNeeded()
//             }, completion: {finished in
//                 print("Animation finished")
//         })
//
//    }
//}
//
//extension SearchViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (view.frame.width - 40) / 2, height: 80)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 400, height: 100)
//    }
//}
//
//extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
//        cell.layer.cornerRadius = 10
//        return cell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? SearchHeaderReusableView else { return UICollectionReusableView() }
//        return header
//    }
