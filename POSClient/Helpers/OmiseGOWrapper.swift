//
//  OmiseGOWrapper.swift
//  POSClient
//
//  Created by Mederic Petit on 20/8/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol WalletLoaderProtocol {
    func getMain(withCallback callback: @escaping Wallet.RetrieveRequestCallback)
}

/// This wrapper has been created for the sake of testing with dependency injection
class WalletLoader: WalletLoaderProtocol {
    func getMain(withCallback callback: @escaping Wallet.RetrieveRequestCallback) {
        Wallet.getMain(using: SessionManager.shared.httpClient, callback: callback)
    }
}

protocol TransactionLoaderProtocol {
    func list(withParams params: TransactionListParams,
              callback: @escaping Transaction.PaginatedListRequestCallback) -> Transaction.PaginatedListRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TransactionLoader: TransactionLoaderProtocol {
    @discardableResult
    func list(withParams params: TransactionListParams,
              callback: @escaping Transaction.PaginatedListRequestCallback) -> Transaction.PaginatedListRequest? {
        return Transaction.list(using: SessionManager.shared.httpClient,
                                params: params,
                                callback: callback)
    }
}

protocol TransactionConsumptionApproverProtocol {
    @discardableResult
    func approve(consumption: TransactionConsumption,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest?
    @discardableResult
    func reject(consumption: TransactionConsumption,
                callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TransactionConsumptionApprover: TransactionConsumptionApproverProtocol {
    @discardableResult
    func approve(consumption: TransactionConsumption,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        return consumption.approve(using: SessionManager.shared.httpClient,
                                   callback: callback)
    }

    @discardableResult
    func reject(consumption: TransactionConsumption,
                callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        return consumption.reject(using: SessionManager.shared.httpClient,
                                  callback: callback)
    }
}

protocol TransactionRequestCreatorProtocol {
    @discardableResult
    func create(withParams params: TransactionRequestCreateParams,
                callback: @escaping TransactionRequest.RetrieveRequestCallback) -> TransactionRequest.RetrieveRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TransactionRequestCreator: TransactionRequestCreatorProtocol {
    @discardableResult
    func create(withParams params: TransactionRequestCreateParams,
                callback: @escaping TransactionRequest.RetrieveRequestCallback) -> TransactionRequest.RetrieveRequest? {
        return TransactionRequest.create(using: SessionManager.shared.httpClient,
                                         params: params,
                                         callback: callback)
    }
}

protocol TransactionConsumptionGeneratorProtocol {
    @discardableResult
    func consume(withParams params: TransactionConsumptionParams,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TransactionConsumptionGenerator: TransactionConsumptionGeneratorProtocol {
    @discardableResult
    func consume(withParams params: TransactionConsumptionParams,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        return TransactionConsumption.consumeTransactionRequest(using: SessionManager.shared.httpClient, params: params, callback: callback)
    }
}

protocol TransactionConsumptionCancellerProtocol {
    @discardableResult
    func cancel(consumption: TransactionConsumption?,
                callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest?
}

class TransactionConsumptionCanceller: TransactionConsumptionCancellerProtocol {
    @discardableResult
    func cancel(consumption: TransactionConsumption?,
                callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        return consumption?.cancel(using: SessionManager.shared.httpClient,
                                   callback: callback)
    }
}

protocol ForgetPasswordWrapperProtocol {
    @discardableResult
    func requestReset(withParams params: UserResetPasswordParams,
                      callback: @escaping Request<EmptyResponse>.Callback) -> Request<EmptyResponse>?

    @discardableResult
    func update(withParams params: UserUpdatePasswordParams,
                callback: @escaping Request<EmptyResponse>.Callback) -> Request<EmptyResponse>?
}

class ForgetPasswordWrapper: ForgetPasswordWrapperProtocol {
    @discardableResult
    func requestReset(withParams params: UserResetPasswordParams,
                      callback: @escaping Request<EmptyResponse>.Callback) -> Request<EmptyResponse>? {
        return User.resetPassword(using: SessionManager.shared.httpClient,
                                  params: params,
                                  callback: callback)
    }

    @discardableResult
    func update(withParams params: UserUpdatePasswordParams,
                callback: @escaping Request<EmptyResponse>.Callback) -> Request<EmptyResponse>? {
        return User.updatePassword(using: SessionManager.shared.httpClient,
                                   params: params,
                                   callback: callback)
    }
}
