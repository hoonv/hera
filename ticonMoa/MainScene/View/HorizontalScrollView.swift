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
    private let edgeInsetConstant: CGFloat = 10
    private let nibName = "HorizontalScrollView"
    let items = ["All", "Coffee", "Cake", "a","bb", "ccc", "dddd"]
    let names = ["box","coffee-cup", "cake", "012-bread-2","fried-chicken-2",
                 "050-burger", "043-pizza"
    ]
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
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
//        cell.titleLabel.text = items[indexPath.row]
        cell.layer.cornerRadius = (frame.height - edgeInsetConstant) / 2
        cell.imageView.image = UIImage(named: names[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
extension HorizontalScrollView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = (frame.height - edgeInsetConstant)
//        let w = max(items[indexPath.row].widthOfString(usingFont: .systemFont(ofSize: 17, weight: .regular)) + 30, h)
        return CGSize(width: h, height: h)
    }
    
}
