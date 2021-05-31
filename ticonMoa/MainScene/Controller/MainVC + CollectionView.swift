//
//  MainVC + CollectionView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/06.
//

import UIKit

extension MainViewController {
    func registerCells() {
        collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
        collectionView.register(UINib(nibName: "MainCategoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainCategoryHeaderView")
        collectionView.register(UINib(nibName: "BrandCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BrandCollectionReusableView")
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)

        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 40), height: 120)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gifticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifticons[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        let data = gifticons[indexPath.section][indexPath.row]
        cell.date.text = data.expiredDate.toStringKST(dateFormat: "yyyy.MM.dd")
        cell.categoryImageView.image = UIImage(named: data.category)
        cell.imageView.image = data.image
        cell.brand.text = data.brand
        cell.name.text = data.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainCategoryHeaderView", for: indexPath) as? MainCategoryHeaderView else { return UICollectionReusableView() }
            header.horizontalScrollView.delegate = self
            header.backgroundColor = .red
            return header
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BrandCollectionReusableView", for: indexPath) as? BrandCollectionReusableView else { return UICollectionReusableView() }
        header.brandLabel.text = gifticons[indexPath.section][0].brand

        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width - 40, height: 64)
        }
        return CGSize(width: view.frame.width - 40, height: 50)

    }
}


extension MainViewController: HorizontalScrollViewDelegate {
    func horizontalScrollView(_ horizontal: HorizontalScrollView, didSelected category: String) {
        viewModel.input.changeCategory(gifticons: allGifticons, category: category)
    }
}
