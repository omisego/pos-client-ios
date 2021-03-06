//
//  QRViewController.swift
//  POSClient
//
//  Created by Mederic Petit on 22/8/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class QRViewController: BaseViewController {
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var qrBorderView: UIView!
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var scanBarButton: UIBarButtonItem!

    var initialBrightness: CGFloat = UIScreen.main.brightness

    private var viewModel: QRViewModelProtocol =
        QRViewModel(transactionRequestBuilder: TransactionRequestBuilder(sessionManager: SessionManager.shared))

    class func initWithViewModel(_ viewModel: QRViewModelProtocol?) -> QRViewController? {
        guard let qrVC: QRViewController = Storyboard.qrCode.viewControllerFromId() else { return nil }
        if let vm = viewModel {
            qrVC.viewModel = vm
        }
        return qrVC
    }

    override func configureView() {
        super.configureView()
        self.navigationItem.title = self.viewModel.title
        self.qrBorderView.addBorder(withColor: Color.greyBorder.uiColor(), width: 1, radius: 0)
        self.hintLabel.text = self.viewModel.hint
        self.view.layoutIfNeeded()
        self.viewModel.buildTransactionRequests()
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onFailure = { [weak self] in
            self?.showError(withMessage: $0.message)
        }
        self.viewModel.onLoadStateChange = { [weak self] in
            $0 ? self?.showLoading() : self?.hideLoading()
        }
        self.viewModel.onTransactionRequestGenerated = { [weak self] in
            guard let self = self else { return }
            self.qrImageView.image = self.viewModel.qrImage(withWidth: self.qrImageView.frame.width)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.main.brightness = self.initialBrightness
    }
}
