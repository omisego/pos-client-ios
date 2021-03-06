//
//  StubGenerator.swift
//  POSClientTests
//
//  Created by Mederic Petit on 31/8/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSClient

class StubGenerator {
    private class func stub<T: Decodable>(forResource resource: String) -> T {
        let bundle = Bundle(for: StubGenerator.self)
        let directoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!
        let filePath = (resource as NSString).appendingPathExtension("json")! as String
        let fixtureFileURL = directoryURL.appendingPathComponent(filePath)
        let data = try! Data(contentsOf: fixtureFileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { try dateDecodingStrategy(decoder: $0) }
        return try! decoder.decode(T.self, from: data)
    }

    class func currentUser() -> User { return self.stub(forResource: "current_user") }

    class func mainWallet() -> Wallet { return self.stub(forResource: "wallet") }

    class func mainWalletSingleBalance() -> Wallet { return self.stub(forResource: "wallet_single_balance") }

    class func transactions() -> [Transaction] { return self.stub(forResource: "transactions") }

    class func pagination() -> Pagination { return self.stub(forResource: "pagination") }

    class func transactionConsumptionAccountGenerated()
        -> TransactionConsumption { return self.stub(forResource: "transaction_consumption_account_generated") }

    class func transactionConsumptionAccountGeneratedWithConfirmation()
        -> TransactionConsumption { return self.stub(forResource: "transaction_consumption_account_generated_with_confirmation") }

    class func transactionConsumptionUserGenerated()
        -> TransactionConsumption { return self.stub(forResource: "transaction_consumption_user_generated") }

    class func transactionRequest() -> TransactionRequest { return self.stub(forResource: "transaction_request") }

    class func transactionRequestWithoutAmount() -> TransactionRequest { return self.stub(forResource: "transaction_request_without_amount") }
}
