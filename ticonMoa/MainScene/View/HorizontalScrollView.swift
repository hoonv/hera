//
//  HorizontalScrollView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/31.
//

import UIKit

protocol HorizontalScrollViewDelegate: class {
    func horizontalScrollView(_ horizontal: HorizontalScrollView, didSelected category: String)
}

class HorizontalScrollView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var contentView: UIView?
    private let edgeInsetConstant: CGFloat = 10
    private let nibName = "HorizontalScrollView"
    var names = ["box","coffee-cup", "cake",
                 "012-bread-2","fried-chicken-2",
                 "050-burger", "043-pizza"]
    var selectedIndex = IndexPath(row: 0, section: 0) {
        didSet {
            collectionView.reloadData()
        }
    }
    var selectedCategory: String {
        return names[selectedIndex.row]
    }
    weak var delegate: HorizontalScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setCategory(categories: [String]) {
        names = categories
        collectionView.reloadData()
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
        cell.layer.cornerRadius = (frame.height - edgeInsetConstant) / 2
        cell.imageView.image = UIImage(named: names[indexPath.row])
        if selectedIndex == indexPath {
            cell.layer.borderWidth = 1.4
            cell.layer.borderColor = UIColor(named: "appColor")?.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        let category = names[indexPath.row]
        delegate?.horizontalScrollView(self, didSelected: category)
    }
    
}
extension HorizontalScrollView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = (frame.height - edgeInsetConstant)
        return CGSize(width: h, height: h)
    }
    
}
