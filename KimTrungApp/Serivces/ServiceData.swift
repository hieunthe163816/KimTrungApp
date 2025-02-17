import Foundation
import KeychainSwift


class ServiceData {
    static var shared = ServiceData()
    
    private init() {}
    
    enum Keys: String {
        case cartFoodKey
    }
    

    
    func clearData(){
        let keychain = KeychainSwift()
        keychain.delete(Keys.cartFoodKey.rawValue)
    }
    
    func setData() {
        let hieu = "[\"foodId: -Nsi0d3CU8g-1vlVOvdW\nfoodName: 20 Chicken McNuggets\nfoodImg: Products/Foods/Food_1.png\nfoodStar: 4.5\nsoldQuantity: 1\nfoodPrice: 10.5\nfoodPrecentPrice: 10\ndetailsFood: Delicious chicken with lettuce, tomato, and cheese.\ncategory: chicken\"]"
        let keychain = KeychainSwift()
        keychain.set(hieu, forKey: Keys.cartFoodKey.rawValue)
    }
    
    func deleteFood(x : Int){
        let keychain = KeychainSwift()
        var listFoods = getCartFood()
        listFoods.remove(at: x)
        
        clearData()
        keychain.set(FoodList(foods: listFoods).description, forKey: Keys.cartFoodKey.rawValue)
        updateNumberCart()
    }
    
    func updateNumberCart(){
        if let mainWindow = UIApplication.shared.keyWindow,
           let tabBarController = mainWindow.rootViewController as? UITabBarController,
           let mainTabBarController = tabBarController as? MainUiTabBarController {
            mainTabBarController.updateCartBadgeValue()
        }
    }
    
    func addCartFood(lst : [FoodCart]){
        let keychain = KeychainSwift()
        var listFoods = getCartFood()
        
        for var y in lst {
            var x : FoodCart = FoodCart(foodId: y.foodId, foodName: y.foodName, foodImg: y.foodImg, foodStar: y.foodStar, soldQuantity: y.soldQuantity, foodPrice: y.foodPrice, foodPrecentPrice: y.foodPrecentPrice, detailsFood: y.detailsFood, category: y.category)
           
            var check : Bool = true
            if listFoods.count == 0 {
                listFoods.append(x)
            } else {
                for i in listFoods.indices{
                    if listFoods[i].foodId == x.foodId {
                        check = false
                        var cart = listFoods[i]
                        let cartQuantity = Int(cart.soldQuantity)! + 1
                        cart.soldQuantity = String(cartQuantity)
                        listFoods[i] = cart
                        break
                    }
                }
                if check {
                    listFoods.append(x)
                }
            }
        }
        clearData()
        keychain.set(FoodList(foods: listFoods).description, forKey: Keys.cartFoodKey.rawValue)
        updateNumberCart()
    }
    
    func addCartFood(y : Food){
        var x : FoodCart = FoodCart(foodId: y.foodId, foodName: y.foodName, foodImg: y.foodImg, foodStar: y.foodStar, soldQuantity: "1", foodPrice: y.foodPrice, foodPrecentPrice: y.foodPrecentPrice, detailsFood: y.detailsFood, category: y.category)
        let keychain = KeychainSwift()
        var listFoods = getCartFood()
        var check : Bool = true
        if listFoods.count == 0 {
            listFoods.append(x)
        } else {
            for i in listFoods.indices{
                if listFoods[i].foodId == x.foodId {
                    check = false
                    var cart = listFoods[i]
                    let cartQuantity = Int(cart.soldQuantity)! + 1
                    cart.soldQuantity = String(cartQuantity)
                    listFoods[i] = cart
                    break
                }
            }
            if check {
                listFoods.append(x)
            }
        }
        
        clearData()
        keychain.set(FoodList(foods: listFoods).description, forKey: Keys.cartFoodKey.rawValue)
    }

    
    
    func getCartFood() -> [FoodCart] {
        let keychain = KeychainSwift()
        if let cartFoodString = keychain.get(Keys.cartFoodKey.rawValue) {
            return convertToFoodList(from: cartFoodString)
        }
        return []
    }
    
    func genDataCart( str : String) -> [FoodCart] {
        
            return convertToFoodList(from: str)
        
    }
    
    func getCartFoodString() -> String {
        let keychain = KeychainSwift()
        if let cartFoodString = keychain.get(Keys.cartFoodKey.rawValue) {
            return cartFoodString
        }
        return ""
    }
    
    func getCartFoodTotal() -> Double {
        let keychain = KeychainSwift()
        var total = 0.0
        if let cartFoodString = keychain.get(Keys.cartFoodKey.rawValue) {
            let listCart = convertToFoodList(from: cartFoodString)
            for x in listCart {
                let price = (Double(x.foodPrice) ?? 0) * (100 - (Double(x.foodPrecentPrice) ?? 0)) / 100
                let boTotal = price * (Double(x.soldQuantity) ?? 0)
                total += boTotal
            }
            return total
        }
        return 0.0
    }
    
    func getCartFoodTotalSt(listCart : [FoodCart]) -> (Double,Int) {
        let keychain = KeychainSwift()
        var total = 0.0
        var y = 0
            for x in listCart {
                let price = (Double(x.foodPrice) ?? 0) * (100 - (Double(x.foodPrecentPrice) ?? 0)) / 100
                let boTotal = price * (Double(x.soldQuantity) ?? 0)
                total += boTotal
            y += 1
        }
        return (total,y)
    }
    
    func convertToFoodList(from descriptionString: String) -> [FoodCart] {
        let keychain = KeychainSwift()
        let components = descriptionString.components(separatedBy: "--------------------")
        
        var foods: [FoodCart] = []
        for component in components {
            let lines = component.components(separatedBy: "\n")
            var foodDict: [String: String] = [:]
            
            for line in lines {
                let keyValue = line.components(separatedBy: ":")
                if keyValue.count == 2 {
                    let key = keyValue[0].trimmingCharacters(in: .whitespaces)
                    let value = keyValue[1].trimmingCharacters(in: .whitespaces)
                    foodDict[key] = value
                }
            }
            
            if !foodDict.isEmpty {
                let food = FoodCart(foodId: foodDict["Food ID"] ?? "",
                                foodName: foodDict["Food"] ?? "",
                                foodImg: foodDict["Image"] ?? "",
                                foodStar: foodDict["Star"] ?? "",
                                soldQuantity: foodDict["Sold Quantity"] ?? "",
                                foodPrice: foodDict["Price"] ?? "",
                                foodPrecentPrice: foodDict["Percent Price"] ?? "",
                                detailsFood: foodDict["Details"] ?? "",
                                category: foodDict["Category"] ?? "")
                foods.append(food)
            }
        }
        
        if !foods.isEmpty {
            //keychain.set(FoodList(foods: foods).description, forKey: Keys.cartFoodKey.rawValue)
            return foods
        } else {
            return []
        }
    }


}

struct FoodCart: Decodable, CustomStringConvertible {
    var foodId: String
    var foodName: String
    var foodImg: String
    var foodStar: String
    var soldQuantity: String
    var foodPrice: String
    var foodPrecentPrice: String
    var detailsFood: String
    var category: String

    var description: String {
        return "Food: \(foodName)\nFood ID: \(foodId)\nImage: \(foodImg)\nStar: \(foodStar)\nSold Quantity: \(soldQuantity)\nPrice: \(foodPrice)\nPercent Price: \(foodPrecentPrice)\nDetails: \(detailsFood)\nCategory: \(category)"
    }
}

struct FoodList: Decodable, CustomStringConvertible {
    var foods: [FoodCart]
    var description: String {
        var result = ""
        for food in foods {
            result += food.description + "\n--------------------\n"
        }
        return result
    }

    // Hàm thêm món ăn vào danh sách
    mutating func addFood(_ food: FoodCart) {
        foods.append(food)
    }
}


