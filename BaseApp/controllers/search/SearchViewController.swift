//
//  SearchViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/04/2024.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    
    private let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        btn.setTitleColor(UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1), for: .normal)
        return btn
    }()
    var recentSearches: [String] = ["Yoga Cake", "Baby Dinosaur Cake", "Candy Cake"]
    var filteredResults: [String] = []
    var isSearching = false

    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Search".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    private let searchView:UIView = {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 24.constraintMultiplierTargetValue.relativeToIphone8Height()
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return card
    }()
    
    
    private let searchTF:UITextField = {
        let lbl = UITextField()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    private let searchIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        return icon
    }()
    
    
    private lazy var searchTypes:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(SearchTabsCell.self, forCellWithReuseIdentifier: "SearchTabsCell")
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.allowsSelection = true
        return cv
    }()
    
    var vendor:Vendor?
    
    private let line:UIView = {
        let view = UIView()
        view.backgroundColor = .clear//UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    @MainActor private lazy var autoCompleteShimmer: UIView = {
        let view = ShimmerView.getShimmer(name: "Locations")
        return view
    }()
    
    @MainActor private lazy var productsShimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "ShopByCategorySubCat")
        return view
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    lazy private var autoCompleteView:UITableView = {
        let tableView = UITableView()
        tableView.register(AutoCompleteCell.self, forCellReuseIdentifier: "AutoCompleteCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var productsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell" )
        collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: "LoadingFooter")
        collectionView.register(VendorProductsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "VendorProductsHeaderView")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var body = ProductsParameters(
        eventDate: OcassionDate.shared.getDate(),
        categoryID: "",
        subcategoryID: "",
        pageindex: "\(1)",
        pagesize: "\(100)",
        pricefrom: "",
        vendorID: "",
        priceto: "",
        locationID: OcassionLocation.shared.getAreaId(),
        searchtxt:"",
        customerID: User.load()?.details?.id
    )
        
    private var searchResults:[Product] = []{
        didSet{
            productsCollectionView.reloadData()
        }
    }
    
    private var autoCompleteResults:[Product] = []{
        didSet{
            autoCompleteView.reloadData()
        }
    }
    
    private var types:[SearchTypeModel] = [SearchTypeModel(type: .Explore, isSelected: true) , SearchTypeModel(type: .Products) , SearchTypeModel(type: .Stores)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        actions()
    }
    
    
    private func setup(){
        self.view.backgroundColor = .white
        [titleLbl , cancelBtn , searchView , /*searchTypes , */ line , contentView].forEach { view in
            self.view.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
            make.height.equalTo(22)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.titleLbl.snp.centerY)
        }
        
        
        [searchTF , searchIcon].forEach { view in
            self.searchView.addSubview(view)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(16)
        }
        
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.constraintMultiplierTargetValue.relativeToIphone8Width())
            make.top.equalTo(self.titleLbl.snp.bottom).offset(19.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchTF.becomeFirstResponder()
    
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(self.searchView.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.line.snp.bottom)
        }
        
        contentView.addSubview(autoCompleteView)
        contentView.addSubview(productsCollectionView)
        autoCompleteView.isHidden = false
        productsCollectionView.isHidden = true
        autoCompleteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        productsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        searchTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        //searchTF.addTarget(self, action: #selector(editingChanged), for: .editingDidBegin)
//        DBManager.shared.fetchSearchHistory { history in
//            DispatchQueue.main.async {
//                if history?.isEmpty == false {
//                    self.showSearchHistory()
//                }
//            }
//        }
    }
    
    
    private func actions(){
        cancelBtn.tap {
            self.dismiss(animated: true)
        }
    }
    
    
    @objc private func editingChanged(textfield:UITextField){
        search(textfield: textfield, isEditing: true)
    }
    
     private func search(textfield:UITextField, isEditing:Bool = true){
         
         if searchTF.text?.count == 0 {
             isSearching = false
             autoCompleteView.reloadData()
         } else {
             isSearching = true
             body.searchtxt = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             if body.searchtxt?.isBlank == true {
                 //            searchResults.removeAll()
                 //            self.showSearchHistory()
                 return
             }
             self.productsCollectionView.isHidden = isEditing
             self.autoCompleteView.isHidden = !isEditing
             self.showShimmer(shimmerView: isEditing ? self.autoCompleteShimmer : self.productsShimmerView)
             if let vendor = vendor {
                 ProductsControllerAPI.vendorProducts(vendorId: vendor.id, text: body.searchtxt) { data, error in
                     self.hideShimmer(shimmerView: isEditing ? self.autoCompleteShimmer : self.productsShimmerView)
                     if let error = error {
                         MainHelper.handleApiError(error)
                     } else {
                         //                if isEditing {
                         //                    if textfield.text?.isBlank == true {
                         //                        self.showSearchHistory()
                         //                    }else{
                         self.autoCompleteResults = data?.products ?? []
                         //                    }
                         //                }else{
                         //                    self.searchResults = data?.products ?? []
                         //                }
                     }
                 }
             }else{
                 ProductsControllerAPI.products(body: body) { data, error in
                     self.hideShimmer(shimmerView: isEditing ? self.autoCompleteShimmer : self.productsShimmerView)
                     if let error = error {
                         MainHelper.handleApiError(error)
                     } else {
                         //                if isEditing {
                         //                    if textfield.text?.isBlank == true {
                         //                        self.showSearchHistory()
                         //                    }else{
                         self.autoCompleteResults = data?.products ?? []
                         //                    }
                         //                }else{
                         //                    self.searchResults = data?.products ?? []
                         //                }
                     }
                 }
             }
         }
    }
    func performSearch(with term: String) {
        if !recentSearches.contains(term) {
            recentSearches.insert(term, at: 0)
            if recentSearches.count > 5 { recentSearches.removeLast() } // Limit
        }

//        filteredResults = data.filter { $0.localizedCaseInsensitiveContains(term) }
        isSearching = true
        autoCompleteView.reloadData()
    }

    
//    private func showSearchHistory(){
//        if searchTF.text?.isBlank == true {
//            self.autoCompleteView.isHidden = false
//            self.productsCollectionView.isHidden = true
//            DBManager.shared.fetchSearchHistory { history in
//                DispatchQueue.main.async {
//                    self.autoCompleteResults = history ?? []
//                }
//            }
//        }else{
//            search(textfield: searchTF, isEditing: true)
//        }
//    }
    
    private func showShimmer(shimmerView:UIView){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            shimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    private func hideShimmer(shimmerView:UIView){
        shimmerView.removeFromSuperview()
    }
    
}
extension SearchViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = searchResults.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 24) / 2, height: 289.constraintMultiplierTargetValue.relativeToIphone8Height())
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = searchResults.get(at: indexPath.row) {
            let vc = ProductDetailsViewController(product: product)
            vc.callback = { cartItem in}
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
    }
    
   
}
extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return autoCompleteResults.count
        return isSearching ? autoCompleteResults.count : recentSearches.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell", for: indexPath) as! AutoCompleteCell
    

        if !isSearching {
            let ne = recentSearches[indexPath.row]
            cell.textLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
            updateLabel(with: ne, searchText: ne, label: cell.textLbl)
            cell.productImg.image = UIImage.init(named: "planeven4")

        } else {
            let text = AppLanguage.isArabic() ? autoCompleteResults[safe: indexPath.row]?.arName ?? "" : autoCompleteResults[safe: indexPath.row]?.name ?? ""
            cell.productImg.download(imagePath: autoCompleteResults[safe: indexPath.row]?.imageURL ?? "", size: CGSize(width: 60, height: 40))
            cell.textLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
            updateLabel(with: text, searchText: body.searchtxt ?? "", label: cell.textLbl)
        }

        return cell
    }
    


    func updateLabel(with text: String, searchText: String, label: UILabel) {
        let attributedString = NSMutableAttributedString(string: text)
        let wordsToHighlight = searchText.split(separator: " ").map { String($0) }
        
        attributedString.addAttribute(.font, value: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)!, range: NSRange(location: 0, length: text.count))
        for word in wordsToHighlight {
            var range = (text as NSString).range(of: word, options: .caseInsensitive)
            
            while range.location != NSNotFound {
                attributedString.addAttribute(.font, value: AppFont.shared.font(family: .Inter, fontWeight: .extrabold, size: 14)!, range: range)
                let nextSearchRange = NSRange(location: range.location + range.length, length: text.count - (range.location + range.length))
                let newRange = (text as NSString).range(of: word, options: .caseInsensitive, range: nextSearchRange)
                range = newRange
            }
        }
        
        label.attributedText = attributedString
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isSearching {
                let selected = recentSearches[indexPath.row]
                isSearching = true
                searchTF.text = selected
                performSearch(with: selected)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
           // self.searchTF.text = autoCompleteResults[safe: indexPath.row]?.searchTxt
            if let product = autoCompleteResults.get(at: indexPath.row) {
                let vc = ProductDetailsViewController(product: product)
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
           // self.search(textfield: self.searchTF, isEditing: false)
            self.searchTF.resignFirstResponder()
            self.searchResults.removeAll()
    //        if let search = autoCompleteResults[safe: indexPath.row]{
    //            DBManager.shared.saveSearchTxt(searchHistory: search)
    //        }

        }
    }
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if !AppLanguage.isArabic() || autoCompleteResults[safe: indexPath.row]?.isHistory == false { return nil }
//        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE".localized) { (action, sourceView, completionHandler) in
//           if let uuid = self.autoCompleteResults[safe: indexPath.row]?.uuid {
//               DBManager.shared.deleteHistoryItem(id: uuid)
//            }
//            tableView.performBatchUpdates {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                self.autoCompleteResults.remove(at: indexPath.row)
//            }
//            completionHandler(true)
//        }
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
//    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if AppLanguage.isArabic() || autoCompleteResults[safe: indexPath.row]?.isHistory == false { return nil }
//        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE".localized) { (action, sourceView, completionHandler) in
//           if let uuid = self.autoCompleteResults[safe: indexPath.row]?.uuid {
//               DBManager.shared.deleteHistoryItem(id: uuid)
//            }
//            tableView.performBatchUpdates {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                self.autoCompleteResults.remove(at: indexPath.row)
//            }
//
//            completionHandler(true)
//        }
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
