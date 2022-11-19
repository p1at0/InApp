//
//  IAPManager.swift
//  InApp
//
//  Created by Abdulla on 17.11.2022.
//

import Foundation
import StoreKit

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    
    var products = [SKProduct]()
    
    private var completion: ((Int) -> Void)?
    
    enum Product: String, CaseIterable {
        case diamond_500
        case diamond_1000
        case diamond_2500
        case diamond_5000
        
        var count: Int {
            switch self {
                
            case .diamond_500:
                return 500
            case .diamond_1000:
                return 1000
            case .diamond_2500:
                return 2500
            case .diamond_5000:
                return 5000
            }
        }
    }
    
    public func fetchProducts() {
        
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Product returned: \(response.products.count)")
        self.products = response.products
    }
    
    public func purchase(product: Product, completion: @escaping ((Int) -> Void)) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product.rawValue }) else {
            return
        }
        self.completion = completion
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // no imp.
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                break
            case .purchased:
                if let product = Product(rawValue: $0.payment.productIdentifier) {
                    completion?(product.count)
                }
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
                break
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
                
            }
            
        })
    }
    
    
}
