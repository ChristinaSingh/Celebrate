//
//  PlacesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/11/2024.
//

import Foundation
import UIKit
import SnapKit
import MapKit
import Combine

class CustomAnnotation: MKPointAnnotation {
    var popUpLocation: PopUpLocation?
}

class PlacesViewController: UIViewController, MKMapViewDelegate {
    
    private let viewModel:PopUpsViewModel = PopUpsViewModel()
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    private let category:PopUPSCategory?
    private var governates:Governorates
    private var popupLocationDate: PopupLocationDate
    
    init(category: PopUPSCategory?, governates: Governorates, popupLocationDate: PopupLocationDate) {
        self.category = category
        self.governates = governates
        self.popupLocationDate = popupLocationDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    lazy private var titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Pop-ups".localized
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    private let mapView:MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    
    lazy private var detailsView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLYZCenterFlowLayout() : YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 8)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: self.category?.imageType?.lowercased() == "restaurants".lowercased() ? 500 : 350)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: PlaceCell.identifier)
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: RestaurantCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubCategoryCell.self, forCellWithReuseIdentifier: "SubCategoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    
    lazy private var filterView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(32)
        }
        return view
    }()

    private var locations: [PopUpLocation] = []{
        didSet{
            detailsView.reloadData()
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        observers()
        actions()
    }
    
    func setup() {
    
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        [backBtn , titleLbl].forEach { view in
            self.headerView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        
        self.view.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.height.equalTo(64)
        }
        self.view.bringSubviewToFront(filterView)
        mapView.delegate = self
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.filterView.snp.bottom)
        }
        self.detailsView.alpha = 0
        self.view.addSubview(detailsView)
        self.detailsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(37)
            let isRestaurants = self.category?.imageType?.lowercased() == "restaurants".lowercased()
            let isVenue = self.category?.imageType?.lowercased() == "elsewhere".lowercased()
            let height : CGFloat = ( isRestaurants ? 500 : ( isVenue ? 446 : 350 ) )
            make.height.equalTo(height)
        }
    }
    
    func observers() {
        viewModel.$loadingSubCategories.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$locations.dropFirst().receive(on: DispatchQueue.main).sink { res in
            self.locations = res?.data ?? []
            self.addCustomMarkers(locations: res?.toCoordinates() ?? [], popUpLocations: self.locations)
        }.store(in: &cancellables)
        
        viewModel.$vendor.dropFirst().receive(on: DispatchQueue.main).sink { vendor in
            guard let vendor else { return }
            let vc = CompanyProfileViewController(vendor: vendor, popupLocationDate: self.popupLocationDate)
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
        }.store(in: &cancellables)
        
        governates[safe: 0]?.isSelected = true
        
        if self.category?.imageType?.lowercased() == "restaurants".lowercased(){
            viewModel.getRestraunts(governateId: governates.first?.id ?? "")
        }else{
            viewModel.getLocations(governateId: governates.first?.id ?? "", categoryId: self.category?.id ?? "")
        }
    }
        
    private func addCustomMarkers(locations: [CLLocationCoordinate2D], popUpLocations: [PopUpLocation]) {
        removeAllAnnotations()
        for (index, coordinate) in locations.enumerated() {
            guard index < popUpLocations.count else { continue }
            let customAnnotation = CustomAnnotation()
            customAnnotation.coordinate = coordinate
            customAnnotation.popUpLocation = popUpLocations[index]
            mapView.addAnnotation(customAnnotation)
        }
        zoomToFitLocations(coordinates: locations, mapView: mapView)
    }
    
    
    private func removeAllAnnotations() {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
    }
    
    func zoomToFitLocations(coordinates: [CLLocationCoordinate2D], mapView: MKMapView) {
        guard !coordinates.isEmpty else { return }
        
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        
        let latDelta = (maxLat - minLat) * 1.2
        let lonDelta = (maxLon - minLon) * 1.2
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserLocation")
                annotationView.image = UIImage(named: "selected_marker")
                annotationView.canShowCallout = true

                return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else { return }
        guard let popUpLocation = customAnnotation.popUpLocation else { return }
        view.image = UIImage(named: "marker")
        self.detailsView.alpha = 1
        self.popupLocationDate.locationId = popUpLocation.id
        if let index = self.locations.firstIndex(where: { location in
            location.id == popUpLocation.id
        }) {
            if let layout = self.detailsView.collectionViewLayout as? YZCenterFlowLayout {
                layout.scrollToPage(atIndex: index, animated: false)
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "selected_marker")
        self.detailsView.alpha = 0
    }
    
    func actions() {
        self.backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension PlacesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return governates.count
        }
        return locations.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            cell.isCelebrate = true
            cell.government = governates.get(at: indexPath.row)
            return cell
        }else if self.category?.imageType?.lowercased() == "restaurants".lowercased(){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.identifier, for: indexPath) as! RestaurantCell
            cell.popUpLocation = locations.get(at: indexPath.row)
            cell.viewSetupsBtn.tap {
                if let location = self.locations.get(at: indexPath.row) {
                    if location.viewCompany == true, let vendorID = location.vendorID {
                        self.viewModel.getVendorDetails(vendorId: vendorID)
                    }else{
                        self.popupLocationDate.cityId = location.cityID
                        let vc = SetupItemsViewController(category: self.category, popupLocationDate: self.popupLocationDate)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.identifier, for: indexPath) as! PlaceCell
            let isVenue = self.category?.imageType?.lowercased() == "elsewhere".lowercased()
            cell.popUpLocation = locations.get(at: indexPath.row)
            cell.isVenue = isVenue
            cell.viewSetupsBtn.tap {
                if let location = self.locations.get(at: indexPath.row) {
                    if location.viewCompany == true, let vendorID = location.vendorID {
                        self.viewModel.getVendorDetails(vendorId: vendorID)
                    }else{
                        self.popupLocationDate.cityId = location.cityID
                        let vc = SetupItemsViewController(category: self.category, popupLocationDate: self.popupLocationDate)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
               
            }
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.category?.imageType?.lowercased() == "restaurants".lowercased(), let restCell = cell as? RestaurantCell {
            restCell.placeImgs.isAutoscrollEnabled = true
            restCell.placeImgs.currentPage = 0
        }else if let placeCell = cell as? PlaceCell {
            placeCell.placeImgs.isAutoscrollEnabled = true
            placeCell.placeImgs.currentPage = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.category?.imageType?.lowercased() == "restaurants".lowercased(), let restCell = cell as? RestaurantCell {
            restCell.placeImgs.isAutoscrollEnabled = false
        }else if let placeCell = cell as? PlaceCell {
            placeCell.placeImgs.isAutoscrollEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            if let category = governates.get(at: indexPath.row){
               let width =  if AppLanguage.isArabic() {
                   category.arName?.width(withConstrainedHeight: 32, font: (AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12))!) ?? 100
                }else{
                    category.name?.width(withConstrainedHeight: 32, font: (AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12))!) ?? 100
                }
                return CGSize(width: width + 24, height: 32)
            }
        }
        let isRestaurants = self.category?.imageType?.lowercased() == "restaurants".lowercased()
        let isVenue = self.category?.imageType?.lowercased() == "elsewhere".lowercased()
        let height : CGFloat = ( isRestaurants ? 500 : ( isVenue ? 446 : 350 ) )
        return CGSize(width: UIScreen.main.bounds.width - 32, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.collectionView ? 12 : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.collectionView ? 12 : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            resetSelection()
            self.governates[safe: indexPath.row]?.isSelected = true
            self.collectionView.reloadData()
            if self.category?.imageType?.lowercased() == "restaurants".lowercased(){
                viewModel.getRestraunts(governateId: self.governates[safe: indexPath.row]?.id ?? "")
            }else{
                self.viewModel.getLocations(governateId: self.governates[safe: indexPath.row]?.id ?? "", categoryId: self.category?.id ?? "")
            }
        }
    }
    private func resetSelection(){
        for (index , _) in self.governates.enumerated() {
            self.governates[safe: index]?.isSelected = false
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let layout = self.detailsView.collectionViewLayout as? YZCenterFlowLayout {
            if let annotation = self.mapView.annotations.first(where: { annotation in
                (annotation as! CustomAnnotation).popUpLocation?.id == self.locations[safe: layout.currentCenteredPage ?? 0]?.id
            }){
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
}

class PlaceCell:UICollectionViewCell {
    
    static let identifier:String = "PlaceCell"
    
    private let cardView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var placeImgs:CarouselCollectionView = {
        let layout = AppLanguage.isArabic() ? RTLYZCenterFlowLayout() : YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 12)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: isVenue ? 254 : 160)
        let img = CarouselCollectionView(frame: .zero, collectionViewFlowLayout: layout)
        img.layer.cornerRadius = 4
        img.clipsToBounds = true
        img.autoscrollTimeInterval = 3.0
        img.isAutoscrollEnabled = false
        img.showsHorizontalScrollIndicator = false
        img.carouselDataSource = self
        img.isPagingEnabled = false
        img.register(PlaceImagsCells.self, forCellWithReuseIdentifier: PlaceImagsCells.identifier)
        return img
    }()
    
    private let pageControl:UIPageControl = {
        let page = UIPageControl()
        page.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        page.pageIndicatorTintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        page.currentPageIndicatorTintColor = .accent
        return page
    }()
    
    
    private let placeNameLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.text = "Park name comes here"
        return lbl
    }()
    
    
    private let servicesView:PlaceDetailsView = {
        let view = PlaceDetailsView()
        return view
    }()
    
    private let restservicesView:RestrauntDetailsView = {
        let view = RestrauntDetailsView()
        return view
    }()
    
    
    private let priceTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.text = "Setups starting from".localized
        return lbl
    }()
    
    
    private let priceLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.text = ""
        return lbl
    }()
    
    let viewSetupsBtn:C8Button = {
        let btn = C8Button()
        btn.setTitle("View Setups".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()
    
    
    private var imgs:[String] = [] {
        didSet {
            placeImgs.setContentOffset(.zero, animated: false)
            placeImgs.reloadData()
        }
    }
    
    var isVenue:Bool = false {
        didSet{
            if isVenue {
                priceTitleLbl.isHidden = true
                priceLbl.isHidden = true
                if AppLanguage.isArabic() {
                    (placeImgs.collectionViewLayout as? RTLYZCenterFlowLayout)?.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: isVenue ? 254 : 160)
                }else{
                    (placeImgs.collectionViewLayout as? YZCenterFlowLayout)?.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: isVenue ? 254 : 160)
                }
                placeImgs.snp.updateConstraints { $0.height.equalTo(254) }
            }else{
                placeImgs.snp.updateConstraints { $0.height.equalTo(160) }
            }
        }
    }
    
    var popUpLocation:PopUpLocation? {
        didSet {
            guard let popUpLocation = popUpLocation else {return}
            self.imgs = popUpLocation.images ?? []
            self.priceLbl.text = "\(popUpLocation.deliveryCharge ?? "") KD"
            self.placeNameLbl.text = AppLanguage.isArabic() ? popUpLocation.nameAr : popUpLocation.name
            self.servicesView.address.titleLbl.text = popUpLocation.city?.name
            self.handleServices(popUpLocation: popUpLocation)
            self.pageControl.numberOfPages = popUpLocation.images?.count ?? 0
            self.pageControl.currentPage = 0
            self.pageControl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            self.handleServices(popUpLocation: popUpLocation)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [placeImgs, placeNameLbl, pageControl, servicesView, priceTitleLbl, priceLbl, viewSetupsBtn].forEach { view in
            self.cardView.addSubview(view)
        }
        
        placeImgs.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(12)
            make.height.equalTo(160)
        }
        
        placeNameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(self.pageControl.snp.bottom)
        }
        
        servicesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(self.placeNameLbl.snp.bottom).offset(8)
            make.height.equalTo(80)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.placeImgs.snp.bottom)
        }
        
        priceTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo( self.servicesView.snp.bottom).offset(15)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.priceTitleLbl.snp.centerY)
            make.leading.equalTo(self.priceTitleLbl.snp.trailing).offset(4)
        }
        
        viewSetupsBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
            make.width.equalTo(104)
            make.height.equalTo(32)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleServices(popUpLocation: PopUpLocation){
        self.servicesView.address.titleLbl.text = AppLanguage.isArabic() ? popUpLocation.city?.arName : popUpLocation.city?.name
        self.servicesView.kidsArea.titleLbl.textColor = popUpLocation.getServices()?.contains(.KidsArea) == false ? .lightGray : .black
        self.servicesView.restaurants.titleLbl.textColor = popUpLocation.getServices()?.contains(.Restaurants) == false ? .lightGray : .black
        self.servicesView.mosque.titleLbl.textColor = popUpLocation.getServices()?.contains(.PrayerRoom) == false ? .lightGray : .black
        self.servicesView.restrooms.titleLbl.textColor = popUpLocation.getServices()?.contains(.RestRooms) == false ? .lightGray : .black
        self.servicesView.sports.titleLbl.textColor = popUpLocation.getServices()?.contains(.SportFields) == false ? .lightGray : .black
        
        self.servicesView.kidsArea.icon.tintColor = popUpLocation.getServices()?.contains(.KidsArea) == false ? .lightGray : .secondary
        self.servicesView.restaurants.icon.tintColor = popUpLocation.getServices()?.contains(.Restaurants) == false ? .lightGray : .secondary
        self.servicesView.mosque.icon.tintColor = popUpLocation.getServices()?.contains(.PrayerRoom) == false ? .lightGray : .secondary
        self.servicesView.restrooms.icon.tintColor = popUpLocation.getServices()?.contains(.RestRooms) == false ? .lightGray : .secondary
        self.servicesView.sports.icon.tintColor = popUpLocation.getServices()?.contains(.SportFields) == false ? .lightGray : .secondary

    }

}

extension PlaceCell: CarouselCollectionViewDataSource{
    var numberOfItems: Int {
        return imgs.count
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier: PlaceImagsCells.identifier, for: fakeIndexPath) as! PlaceImagsCells
        cell.placeImg.download(imagePath: imgs[safe: index] ?? "", size: carouselCollectionView.frame.size)
        return cell
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
    }

}

class RestaurantCell:UICollectionViewCell {
    
    static let identifier:String = "RestaurantCell"
    
    private let cardView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var placeImgs:CarouselCollectionView = {
        let layout = AppLanguage.isArabic() ? RTLYZCenterFlowLayout() : YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 12)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 254)
        let img = CarouselCollectionView(frame: .zero, collectionViewFlowLayout: layout)
        img.layer.cornerRadius = 4
        img.clipsToBounds = true
        img.autoscrollTimeInterval = 3.0
        img.isAutoscrollEnabled = false
        img.showsHorizontalScrollIndicator = false
        img.carouselDataSource = self
        img.isPagingEnabled = false
        img.register(PlaceImagsCells.self, forCellWithReuseIdentifier: PlaceImagsCells.identifier)
        return img
    }()
    
    private let pageControl:UIPageControl = {
        let page = UIPageControl()
        page.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        page.pageIndicatorTintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        page.currentPageIndicatorTintColor = .accent
        return page
    }()
    
    
    private let placeNameLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    private let restservicesView:RestrauntDetailsView = {
        let view = RestrauntDetailsView()
        return view
    }()
    
    
    private let priceTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.text = "Setups starting from".localized
        return lbl
    }()
    
    
    private let priceLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.text = ""
        return lbl
    }()
    
    let viewSetupsBtn:C8Button = {
        let btn = C8Button()
        btn.setTitle("View styles".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()
    
    
    private let img:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 27.5
        img.clipsToBounds = true
        return img
    }()
    
    private var imgs:[String] = [] {
        didSet {
            placeImgs.setContentOffset(.zero, animated: false)
            placeImgs.reloadData()
        }
    }
    
    var popUpLocation:PopUpLocation? {
        didSet {
            guard let popUpLocation = popUpLocation else {return}
            self.imgs = popUpLocation.images ?? []
            self.priceLbl.text = "\(popUpLocation.deliveryCharge ?? "") KD"
            self.placeNameLbl.text = AppLanguage.isArabic() ? popUpLocation.nameAr : popUpLocation.name
            self.handleServices(popUpLocation: popUpLocation)
            self.pageControl.numberOfPages = popUpLocation.images?.count ?? 0
            self.pageControl.currentPage = 0
            self.img.download(imagePath: popUpLocation.logo ?? "", size: CGSize(width: 80, height: 80))
            self.pageControl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [placeImgs, pageControl, img , placeNameLbl, restservicesView, priceTitleLbl, priceLbl, viewSetupsBtn].forEach { view in
            self.cardView.addSubview(view)
        }
    
        placeImgs.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
            make.height.equalTo(254)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.placeImgs.snp.bottom)
        }
        
        placeNameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(self.pageControl.snp.bottom)
        }
        
        img.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.width.height.equalTo(55)
            make.centerY.equalTo(self.placeNameLbl.snp.centerY)
        }
        
        restservicesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(self.placeNameLbl.snp.bottom).offset(8)
            make.height.equalTo(120)
        }
        
        priceTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(self.restservicesView.snp.bottom).offset(15)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.priceTitleLbl.snp.centerY)
            make.leading.equalTo(self.priceTitleLbl.snp.trailing).offset(4)
        }
        
        viewSetupsBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
            make.width.equalTo(104)
            make.height.equalTo(32)
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleServices(popUpLocation: PopUpLocation){
        self.restservicesView.address.titleLbl.text = AppLanguage.isArabic() ? popUpLocation.city?.arName : popUpLocation.city?.name
        self.restservicesView.cuisine.titleLbl.text = AppLanguage.isArabic() ? popUpLocation.city?.arName : popUpLocation.city?.name
        self.restservicesView.parking.titleLbl.textColor = popUpLocation.getServices()?.contains(.ValetParking) == false ? .lightGray : .black
        self.restservicesView.singing.titleLbl.textColor = popUpLocation.getServices()?.contains(.CelebrationSinging) == false ? .lightGray : .black
        self.restservicesView.privateAccess.titleLbl.textColor = popUpLocation.getServices()?.contains(.PrivateAccess) == false ? .lightGray : .black
        self.restservicesView.rooftop.titleLbl.textColor = popUpLocation.getServices()?.contains(.RoofTop) == false ? .lightGray : .black
        self.restservicesView.balcony.titleLbl.textColor = popUpLocation.getServices()?.contains(.TerraceBalcony) == false ? .lightGray : .black
        self.restservicesView.smokingArea.titleLbl.textColor = popUpLocation.getServices()?.contains(.SmokeArea) == false ? .lightGray : .black
        self.restservicesView.cake.titleLbl.textColor = popUpLocation.getServices()?.contains(.CelebrationCakeSweets) == false ? .lightGray : .black
        self.restservicesView.privateRoom.titleLbl.textColor = popUpLocation.getServices()?.contains(.PrivateCabinetRoom) == false ? .lightGray : .black
        
        self.restservicesView.parking.icon.tintColor = popUpLocation.getServices()?.contains(.ValetParking) == false ? .lightGray : .secondary
        self.restservicesView.singing.icon.tintColor = popUpLocation.getServices()?.contains(.CelebrationSinging) == false ? .lightGray : .secondary
        self.restservicesView.privateAccess.icon.tintColor = popUpLocation.getServices()?.contains(.PrivateAccess) == false ? .lightGray : .secondary
        self.restservicesView.rooftop.icon.tintColor = popUpLocation.getServices()?.contains(.RoofTop) == false ? .lightGray : .secondary
        self.restservicesView.balcony.icon.tintColor = popUpLocation.getServices()?.contains(.TerraceBalcony) == false ? .lightGray : .secondary
        self.restservicesView.smokingArea.icon.tintColor = popUpLocation.getServices()?.contains(.SmokeArea) == false ? .lightGray : .secondary
        self.restservicesView.cake.icon.tintColor = popUpLocation.getServices()?.contains(.CelebrationCakeSweets) == false ? .lightGray : .secondary
        self.restservicesView.privateRoom.icon.tintColor = popUpLocation.getServices()?.contains(.PrivateCabinetRoom) == false ? .lightGray : .secondary
    }

}

extension RestaurantCell: CarouselCollectionViewDataSource{
    var numberOfItems: Int {
        return imgs.count
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier: PlaceImagsCells.identifier, for: fakeIndexPath) as! PlaceImagsCells
        cell.placeImg.download(imagePath: imgs[safe: index] ?? "", size: carouselCollectionView.frame.size)
        return cell
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
    }

}

class PlaceDetailsView:UIView {
    
    let address:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "", iconImage: UIImage(named: "location_address"))
        return lbl
    }()
    
    let kidsArea:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Kids play area".localized, iconImage: UIImage(named: "kids"))
        return lbl
    }()
    
    let restaurants:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Restaurants".localized, iconImage: UIImage(named: "food"))
        return lbl
    }()
    
    let mosque:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Prayer room".localized, iconImage: UIImage(named: "mosque"))
        return lbl
    }()
    
    
    let restrooms:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Restrooms".localized, iconImage: UIImage(named: "toilet"))
        return lbl
    }()
    
    let sports:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Sport fields".localized, iconImage: UIImage(named: "sports"))
        return lbl
    }()
    
    
    lazy private var pkrstackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [kidsArea, restaurants, mosque])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()
    
    
    lazy private var prsstackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ restrooms, sports, PlaceIconedLabel(title: "", iconImage: nil)])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy private var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [address, pkrstackView, prsstackView])
        stack.distribution = .fillEqually
        stack.axis = .vertical
       // stack.alignment = .leading
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RestrauntDetailsView:UIView {
    
    let address:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "", iconImage: UIImage(named: "location_address"))
        return lbl
    }()
    
    let cuisine:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Cuisine", iconImage: nil)
        lbl.titleLbl.backgroundColor = .red
        lbl.titleLbl.textAlignment = .center
        lbl.titleLbl.textColor = .white
        lbl.titleLbl.layer.cornerRadius = 5
        lbl.titleLbl.layer.masksToBounds = true

        
        return lbl
    }()
    
    let parking:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Valet Parking".localized, iconImage: UIImage(named: "tabler_parking"))
        return lbl
    }()
    
    
    let singing:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "⁠Celebration Singing".localized, iconImage: UIImage(named: "music"))
        return lbl
    }()
    
    let privateAccess:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Private Access".localized, iconImage: UIImage(named: "food"))
        return lbl
    }()
    
    let rooftop:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Rooftop".localized, iconImage: UIImage(named: "roof"))
        return lbl
    }()
    
    
    let balcony:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "⁠Terrace/Balcony".localized, iconImage: UIImage(named: "mdi_terrace"))
        return lbl
    }()
    
    
    let smokingArea:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "⁠Smoking Area".localized, iconImage: UIImage(named: "mdi_smoking"))
        return lbl
    }()
    
    let cake:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "⁠Celebration Cake/Sweets".localized, iconImage: UIImage(named: "cake"))
        return lbl
    }()
    
    let privateRoom:PlaceIconedLabel = {
        let lbl = PlaceIconedLabel(title: "Private Cabinet/Room".localized, iconImage: UIImage(named: "cabain"))
        return lbl
    }()
    
    lazy private var cuistackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [address, cuisine, PlaceIconedLabel(title: "", iconImage: nil)])
        stack.distribution = AppLanguage.isArabic() ? .fillEqually : .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy private var pspstackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balcony, parking, smokingArea])
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy private var rbsstackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ rooftop, cake, PlaceIconedLabel(title: "", iconImage: nil)])
        stack.distribution = AppLanguage.isArabic() ? .fillEqually : .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy private var cbstackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [privateRoom, singing])
        if AppLanguage.isArabic() {
            stack.addArrangedSubview(PlaceIconedLabel(title: "", iconImage: nil))
        }
        stack.distribution = AppLanguage.isArabic() ? .fillEqually : .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy private var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cuistackView, pspstackView, rbsstackView, cbstackView])
        stack.distribution = .fillEqually
        stack.axis = .vertical
       // stack.alignment = .leading
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlaceIconedLabel:UIView{
    let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    let icon:UIImageView = {
        let img = UIImageView(image: UIImage(named: "location_address"))
        return img
    }()
    
        
    init(title:String,iconImage:UIImage?) {
        self.titleLbl.text = title
        self.icon.image = iconImage
        super.init(frame: .zero)
        self.addSubview(icon)
        self.addSubview(titleLbl)
        
        self.icon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.icon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlaceImagsCells:UICollectionViewCell{
 
    static let identifier:String = "PlaceImagsCells"
    
    let placeImg:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(placeImg)
        placeImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
