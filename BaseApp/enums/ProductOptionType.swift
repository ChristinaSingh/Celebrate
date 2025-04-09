//
//  ProductOptionType.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import Foundation
import UIKit

protocol ProductOptionDelegate {
    func select(qty:Int , section:Int , tvSection:Int , item:Int)
    func textChanged(text:String , section:Int , tvSection:Int , row:Int)
    func quantityChanged(count:Int ,section:Int , tvSection:Int , row:Int)
    func timesType(timeType:TimeSlotType, section:Int)
}

enum ProductOption : Int{
    case BANNER = 0
    case DELIVERY = 4
    case TITLE = 1
    case DESCRIPTION = 2
    case CANCELLATION = 3
    case SSSQ = 8
    case SSMQ = 7
    case MSSQ = 6
    case MSMQ = 5
    case YESNO = 9
    case INPUT = 10
    
    static func type(type:String) -> ProductOption{
        switch type {
        case "SSSQ":
            return .SSSQ
        case "SSMQ":
            return .SSMQ
        case "MSSQ":
            return .MSSQ
        case "MSMQ":
            return .MSMQ
        case "YESNO":
            return .YESNO
        case "INPUT":
            return .INPUT
        default:
            return .INPUT
        }
    }
    
    func numberOfRows(productDetails:ProductDetails? , section:Int) -> Int{
        switch self {
        case .BANNER , .TITLE:
            return 1
        case .DESCRIPTION :
            return productDetails?.isDescriptionCollapsed == true ? 0 : 1
        case .CANCELLATION:
            return productDetails?.isCancellationPolicyCollapsed == true ? 0 : 1
        case .DELIVERY :
            return productDetails?.isDeliveryTimeCollapsed == true ? 0 : 1
        case .SSSQ , .SSMQ , .MSSQ , .MSMQ :
            return productDetails?.options?[section].isOptionCollapsed == true ? 0 : productDetails?.options?.get(at: section)?.config?.res?.count ?? 0
        case .YESNO, .INPUT:
            return 1
        }
    }
    
    func cellForRow(productDetails: ProductDetails? , timeSlots:DeliveryTimes? , tableView:UITableView , indexPath:IndexPath? , topSectionsCount:Int, delegate:ProductOptionDelegate?) -> UITableViewCell {
        guard let indexPath = indexPath else {return UITableViewCell()}
        switch self {
        case .BANNER:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsBannerCell", for: indexPath) as! ProductDetailsBannerCell
            cell.extraImages = productDetails?.extraImages
            cell.defaultImg = ExtraImage(cloudinaryUUID: nil, url: productDetails?.imageURL)
            return cell
        case .DELIVERY:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDeliveryTimeCell", for: indexPath) as! ProductDetailsDeliveryTimeCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.deliveryTimes = timeSlots
            cell.timeSlotType.timeTypeChanged = { type in
                delegate?.timesType(timeType: type, section: indexPath.section)
                UIView.performWithoutAnimation {
//                    tableView.performBatchUpdates({
//                        tableView.beginUpdates()
//                        tableView.reloadRows(at: [indexPath], with: .automatic)
//                        tableView.endUpdates()
//                    }, completion: nil)
                    tableView.reloadData()
                    
                }
            }
            return cell
        case .TITLE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsTitleCell", for: indexPath) as! ProductDetailsTitleCell
            cell.title = AppLanguage.isArabic() ? productDetails?.arName : productDetails?.name
            cell.price = productDetails?.price
            cell.isPayUpOnApproval = productDetails?.requiresApproval == true
            return cell
        case .DESCRIPTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDescriptionCell", for: indexPath) as! ProductDetailsDescriptionCell
            cell.desc = AppLanguage.isArabic() ? productDetails?.arDescription : productDetails?.productDescription
            return cell
        case .CANCELLATION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCancellationCell", for: indexPath) as! ProductDetailsCancellationCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.desc = AppLanguage.isArabic() ? productDetails?.arCancellationPolicy : productDetails?.cancellationPolicy
            return cell
        case .SSSQ:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsSSSQCell", for: indexPath) as! ProductDetailsSSSQCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.option = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.config?.res?.get(at: indexPath.row)
            return cell
        case .SSMQ:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsSSMQCell", for: indexPath) as! ProductDetailsSSMQCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.maxSelection = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.selectedCount() ?? 0 > 0
            cell.option = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.config?.res?.get(at: indexPath.row)
            cell.stepper.valueChanged = { value in
                delegate?.quantityChanged(count: value, section: indexPath.section - topSectionsCount, tvSection: indexPath.section, row: indexPath.row)
            }
            cell.addBtn.tap {
                delegate?.select(qty: 1, section: indexPath.section - topSectionsCount, tvSection: indexPath.section, item: indexPath.row)
            }
            return cell
        case .MSSQ:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsMSSQCell", for: indexPath) as! ProductDetailsMSSQCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.option = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.config?.res?.get(at: indexPath.row)
            return cell
        case .MSMQ:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsMSMQCell", for: indexPath) as! ProductDetailsMSMQCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            let selectedQty = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.selectedQty() ?? 0
            let maxQty = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.vMax?.toInt() ?? 0
            cell.maxSelection = selectedQty >= maxQty
            cell.option = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.config?.res?.get(at: indexPath.row)
            cell.stepper.valueChanged = { value in
                delegate?.quantityChanged(count: value, section: indexPath.section - topSectionsCount, tvSection: indexPath.section, row: indexPath.row)
            }
            cell.addBtn.tap {
                delegate?.select(qty: 1, section: indexPath.section - topSectionsCount, tvSection: indexPath.section, item: indexPath.row)
            }
            return cell
        case .YESNO:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsYESNOCell", for: indexPath) as! ProductDetailsYESNOCell
            cell.option = productDetails?.options?.get(at: indexPath.section - topSectionsCount)
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.isFirst = indexPath.row == 0
            return cell
        case .INPUT:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsINPUTCell", for: indexPath) as! ProductDetailsINPUTCell
            cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.isFirst = indexPath.row == 0
            cell.option = productDetails?.options?.get(at: indexPath.section - topSectionsCount)
            cell.isRequired = productDetails?.options?.get(at: indexPath.section - topSectionsCount)?.optionRequired == true
            cell.textChanged = { text in
                delegate?.textChanged(text: text, section: indexPath.section - topSectionsCount, tvSection: indexPath.section, row: indexPath.row)
            }
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView , productDetails: ProductDetails? , viewForHeaderInSection:Int, section: Int , completion: @escaping ((ProductDetails?) -> Void)) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductDetailsSectionHeader") as? ProductDetailsSectionHeader
        let title = switch self {
        case .DELIVERY:
            ("Select delivery time".localized , "", true)
        case .DESCRIPTION:
            ("Description".localized , "" , false)
        case .CANCELLATION:
            ("Cancellation policy".localized , "", false)
        case .SSSQ , .SSMQ , .MSSQ , .MSMQ :
            getHeader(productDetails: productDetails, section: section)
        default:
            ("" , "",  false)
        }
        header?.title = title.0
        header?.subTitle = title.1
        header?.isRequired = title.2
        switch self {
        case .DELIVERY:
            header?.isExpanded = productDetails?.isDeliveryTimeCollapsed == false
            break
        case .DESCRIPTION:
            header?.isExpanded = productDetails?.isDescriptionCollapsed == false
            header?.expandedCorners()
            break
        case .CANCELLATION:
            header?.isExpanded = productDetails?.isCancellationPolicyCollapsed == false
            if productDetails?.isCancellationPolicyCollapsed == false {
                header?.containerView.layer.cornerRadius = 0
            }else{
                header?.bottomCorners()
            }
            break
        case .SSSQ , .SSMQ , .MSSQ , .MSMQ:
            header?.isExpanded = productDetails?.options?[section].isOptionCollapsed == false
            break
        default:
            break
        }
        header?.actionBtn.tap {
            self.toggelSectionHeader(tableView, header: header, productDetails: productDetails, viewForHeaderInSection: viewForHeaderInSection, section: section , completion: completion)
        }
        return header
    }
    
    private func toggelSectionHeader(_ tableView: UITableView , header:ProductDetailsSectionHeader? , productDetails: ProductDetails? , viewForHeaderInSection:Int, section: Int , completion: @escaping ((ProductDetails?) -> Void)){
        switch self {
        case .DELIVERY:
            productDetails?.isDeliveryTimeCollapsed.toggle()
            break
        case .DESCRIPTION:
            productDetails?.isDescriptionCollapsed.toggle()
            break
        case .CANCELLATION:
            productDetails?.isCancellationPolicyCollapsed.toggle()
            break
        case .SSSQ , .SSMQ , .MSSQ , .MSMQ:
            productDetails?.options?[section].isOptionCollapsed.toggle()
            break
        default:
            break
        }
        completion(productDetails)
        tableView.reloadData()
    }
    
    private func getHeader(productDetails:ProductDetails? , section: Int) -> (String , String, Bool){
        let name = AppLanguage.isArabic() ? productDetails?.options?.get(at: section)?.arName : productDetails?.options?.get(at: section)?.name
        let min = productDetails?.options?.get(at: section)?.minSelection ?? ""
        let max = productDetails?.options?.get(at: section)?.maxSelection ?? ""
        if productDetails?.options?.get(at: section)?.optionRequired == true {
            return ("\(name ?? "")", "" , true)
        }else if productDetails?.options?.get(at: section)?.freeSelection == "1"{
            return ("\(name ?? "") \("(Optional)".localized)", "", false )
        }else if self == .MSMQ || self == .SSMQ {
            if min.toInt() ?? 0 > 0 {
                if productDetails?.showseatsavailable == 1 {
                    return ("\(name ?? "")", "(\(productDetails?.showseatsavailable ?? 0) \("left".localized)" , true)
                }else{
                    return ("\(name ?? "")", "" , true)
                }
            }else{
                return ("\(name ?? "")", "", false)
            }
        }else if self == .MSSQ {
            return ("\(name ?? "")", AppLanguage.isArabic() ? "(حدد الحد الادني \(min) & الحد الاقصي \(max))" : "(Select Min. \(min) & Max. \(max))", min.toInt() ?? 0 > 0)
        }else if self == .SSSQ {
            return ("\(name ?? "")", AppLanguage.isArabic() ? "(اختر ١)" : "(Choose 1)", true)
        }
        return ("" , "", false)
    }
    
    func tableView(_ tableView: UITableView,productDetails: inout ProductDetails? , didSelectRowAt indexPath: IndexPath , section: Int) {
        switch self {
        case .SSSQ:
            if productDetails?.options?[section].config?.res?[safe: indexPath.row]?.checked == true {return}
            _ = selectSSSQ(productDetails: &productDetails, section: section, indexPath: indexPath)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
                UIView.performWithoutAnimation {
//                    tableView.beginUpdates()
//                    if indices.0 == -1 {
//                        tableView.reloadRows(at: [indexPath], with: .automatic)
//                    }else{
//                        tableView.reloadRows(at: [IndexPath(row: indices.0, section: indexPath.section) , IndexPath(row: indices.1, section: indexPath.section)], with: .automatic)
//                    }
//                    tableView.endUpdates()
                    tableView.reloadData()
                }
            }
        case .MSSQ:
            if productDetails?.options?[safe: section]?.checkOptionsCount() ?? 0 >= Int(productDetails?.options?[safe: section]?.maxSelection ?? "0") ?? 0  && productDetails?.options?[safe: section]?.config?.res?[safe: indexPath.row]?.checked == false{
                return
            }
            productDetails?.options?[section].config?.res?[safe: indexPath.row]?.checked.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
                UIView.performWithoutAnimation {
//                    tableView.beginUpdates()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                    tableView.endUpdates()
                    tableView.reloadData()
                }
            }
        case .YESNO:
            productDetails?.options?[section].isSelected.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
                UIView.performWithoutAnimation {
//                    tableView.beginUpdates()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                    tableView.endUpdates()
                    tableView.reloadData()
                }
            }
            break
        default:
            break
        }
    }
    
    private func selectSSSQ(productDetails: inout ProductDetails? , section: Int, indexPath: IndexPath) -> (Int , Int){
        guard let product = productDetails else { return ( -1 , -1) }
        var prevIndex = -1
        if let index = product.options?[section].config?.res?.firstIndex(where: { option in
            option.checked
        }){
            prevIndex = index
            product.options?[safe: section]?.config?.res?[safe : index]?.checked = false
        }
        product.options?[safe: section]?.config?.res?[safe: indexPath.row]?.checked = true
        productDetails = product
        return (prevIndex , indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, productDetails:ProductDetails?, heightForHeaderInSection section: Int) -> CGFloat {
        switch self {
        case .SSSQ , .SSMQ ,  .MSSQ , .MSMQ , .DELIVERY , .DESCRIPTION , .CANCELLATION:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch self {
        case .DESCRIPTION:
            return 0
        default:
            return 24
        }
    }
    

    func height(timeSlots:DeliveryTimes?) -> CGFloat{
        switch self {
        case .BANNER:
            return 335.constraintMultiplierTargetValue.relativeToIphone8Height()
        case .DELIVERY:
            let am = Int(Double((timeSlots?.am()?.count ?? 0) / 2).rounded(.up))
            let pm = Int(Double((timeSlots?.pm()?.count ?? 0) / 2).rounded(.up))
            let pmSpaces = (pm + 1) * 16
            let amSpaces = (am + 1) * 16
            return timeSlots?.timeType == .AM ? CGFloat((am * 84) + 70 + amSpaces) : CGFloat((pm * 84) + 70 + pmSpaces)
        case .YESNO:
            return 60
        case .INPUT:
            return 160
        case .SSSQ , .SSMQ ,  .MSSQ , .MSMQ  , .DESCRIPTION , .CANCELLATION, .TITLE:
            return UITableView.automaticDimension
        }
    }
    
}
