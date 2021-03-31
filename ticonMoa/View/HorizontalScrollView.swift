//
//  HorizontalScrollView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/31.
//

import UIKit

class HorizontalScrollView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var contentView: UIView?

    let nibName = "HorizontalScrollView"
    let items = ["All", "Coffee", "Cake", "A"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
     }
     
     required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
     }
    
    private func setup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        print(frame)
        contentView = view
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

extension HorizontalScrollView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        cell.titleLabel.text = items[indexPath.row]
        cell.layer.cornerRadius = (frame.height - 10) / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
}
extension HorizontalScrollView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = (frame.height - 10)
        let w = max(items[indexPath.row].widthOfString(usingFont: .systemFont(ofSize: 17, weight: .regular)) + 30, h)
        return CGSize(width: w, height: h)
    }
    
}
