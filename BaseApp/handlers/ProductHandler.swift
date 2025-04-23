//
//  ProductHandler.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import Foundation

class ProductHandler: NSObject {
    
    class func bindObject(product: inout ProductDetails , cartItem:CartItem){
        guard let options = product.options else {return}
        for (index , _) in options.enumerated() {
            for option in cartItem.productOption ?? [] {
                switch ProductOption.type(type: option.type ?? "") {
                case .MSMQ , .MSSQ , .SSSQ , .SSMQ:
                    if product.options?[index].id == option.id {
                        for selectedValue in option.value ?? [] {
                            for (mIndex , productOpion) in (product.options?[index].config?.res ?? []).enumerated() {
                                if selectedValue.valueID?.string == productOpion.id {
                                    product.options?[index].config?.res?[mIndex].checked = true
                                    if ProductOption.type(type: option.type ?? "") != .SSSQ && ProductOption.type(type: option.type ?? "") != .MSSQ {
                                        if selectedValue.qty?.integer != -1 {
                                            product.options?[index].config?.res?[mIndex].qty = selectedValue.qty?.integer ?? 0
                                        }else {
                                            product.options?[index].config?.res?[mIndex].qty = Int(selectedValue.qty?.string ?? "0") ?? 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break
                case .INPUT:
                    if product.options?[index].id == option.id {
                        if option.value?.count ?? 0 > 0 {
                            product.options?[index].inputText = option.value?[0].value ?? ""
                        }
                    }
                    break
                case .YESNO:
                    if product.options?[index].id == option.id {
                        if option.value?.count ?? 0 > 0 {
                            product.options?[index].isSelected = option.value?[0].qty?.integer == 1
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    
    @MainActor class func createCartBody(product: ProductDetails, date:String? , location:String? , timeSlotID:String? = nil , selections:[CartBodyOption]?, addressid: String?, cartTime:String?, friendID:String?) -> CartBody{
        return CartBody(productID: product.id, resourceSlotID: timeSlotID, config: selections, cartID: nil, deliveryDate: date == nil ? OcassionDate.shared.getDate() : date, ocassionID: "1", locationID: location == nil ? OcassionLocation.shared.getAreaId() : location, addressid: addressid, cartTime: cartTime, friendID: friendID)
    }
    //quantity
    class func isvalidSelections(product: ProductDetails) -> (message:String?, section:Int?, selections:[CartBodyOption]?) {
        var cartOptions:[CartBodyOption] = []
        for (index , var option) in (product.options ?? []).enumerated() {
            let type = ProductOption.type(type: option.type ?? "")
            switch  type{
            case .INPUT:
                if option.optionRequired == true && option.inputText.isEmpty{
                    let name = AppLanguage.isArabic() ? option.arName ?? "" : option.name
                    return ("\(name ?? "") \("isRequired".localized)" , index , nil)
                }else if !option.inputText.isEmpty{
                    var value : [Values] = []
                    value.append(Values.string(option.inputText))
                    let cartOption = CartBodyOption(id: option.id, values: value)
                    cartOptions.append(cartOption)
                }
                break
            case .YESNO:
                if option.optionRequired == true && !option.isSelected{
                    let name = AppLanguage.isArabic() ? option.arName ?? "" : option.name
                    return ("\(name ?? "") \("isRequired".localized)" , index , nil)
                }else if option.isSelected{
                    var value : [Values] = []
                    value.append(Values.string("\(option.isSelected)"))
                    let cartOption = CartBodyOption(id: option.id, values: value)
                    cartOptions.append(cartOption)
                }
                break
            case .MSMQ , .MSSQ , .SSSQ , .SSMQ:
                var selectionCount = 0
                for config in option.config?.res ?? [] {
                    if config.checked {
                        selectionCount += 1
                    }
                }
                if type == .SSSQ && option.optionRequired == false{
                    option.minSelection = "0"
                }
                if Int((option.minSelection ?? "0")) ?? 0 > 0 && selectionCount < Int((option.minSelection ?? "0")) ?? 0 {
                    let name = AppLanguage.isArabic() ? option.arName ?? "" : option.name
                    return ("\("please".localized) \(name ?? "")" , index , nil)
                }else if (Int((option.minSelection ?? "0" )) ?? 0 > 0 && selectionCount >= Int((option.minSelection ?? "0" )) ?? 0) || ((Int((option.minSelection ?? "0" )) ?? 0 <= 0 && selectionCount >= Int((option.minSelection ?? "0" )) ?? 0)) {
                    for config in option.config?.res ?? []{
                        var value : [Values] = []
                        if config.checked {
                            if config.qty == 0 {
                                value.append(Values.value(CartBodyValue(id: config.id ?? "", qty: 1)))
                            }else{
                                value.append(Values.value(CartBodyValue(id: config.id ?? "", qty: config.qty)))
                            }
                            let cartOption = CartBodyOption(id: option.id, values: value)
                            cartOptions.append(cartOption)
                        }
                    }
                }
                break
            default:break
            }
        }
       return (nil , nil, cartOptions)
    }
    
    
    
    class func calcTotal(productDetails:ProductDetails?) -> (isSelected:Bool? , total:String?){
        guard let product = productDetails else {return (nil , nil)}
        if product.prepTimeNotAvailable == true {return (nil , nil)}
        if product.isLocationAvailable == false {return (nil , nil)}
        if product.isResourceAvailable == false {return (nil , nil)}
        
        var optionsTotal:Double = 0.0
        var optionSelected:Bool = false
        for option in product.options ?? [] {
            if option.isSelected {
                optionSelected = true
                optionsTotal += Double(option.price ?? "0") ?? 0
            }
            for config in option.config?.res ?? [] {
                if config.checked || config.qty > 0 {
                    optionSelected = true
                    if config.qty > 0 && config.checked {
                        optionsTotal += (Double(config.rate ?? "0") ?? 0) * Double(config.qty)
                    }else if config.checked {
                        optionsTotal += (Double(config.rate ?? "0") ?? 0)
                    }
                }
            }
        }
        return (optionSelected , "\(optionsTotal + (Double(product.price ?? "0") ?? 0))".formatPrice())
    }
    
}
