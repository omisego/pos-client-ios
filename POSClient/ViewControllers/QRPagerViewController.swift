//
//  QRPagerViewController.swift
//  POSClient
//
//  Created by Mederic Petit on 5/2/19.
//  Copyright © 2019 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation
import OmiseGO
import XLPagerTabStrip

class QRPagerViewController: ButtonBarPagerTabStripViewController, Toastable {
    private var viewModel: QRPagerViewModelProtocol = QRPagerViewModel()
    let transactionRequestDetailSegueIdentifier = "showTransactionRequestDetail"

    private var qrViewModel: QRViewModelProtocol?

    class func initWithViewModel(_ viewModel: QRPagerViewModelProtocol,
                                 qrViewModel: QRViewModelProtocol) -> QRPagerViewController? {
        guard let qrPagerVC: QRPagerViewController = Storyboard.qrCode.viewControllerFromId() else { return nil }
        qrPagerVC.viewModel = viewModel
        qrPagerVC.qrViewModel = qrViewModel
        return qrPagerVC
    }

    override func viewDidLoad() {
        self.navigationItem.title = self.viewModel.title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setupPagerMenuBar()
        super.viewDidLoad()
        self.configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.observerTabBarSelectNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.stopObserving()
    }

    private func setupPagerMenuBar() {
        self.settings.style.buttonBarBackgroundColor = .white
        self.settings.style.buttonBarItemFont = Font.avenirMedium.withSize(17)
        self.settings.style.selectedBarHeight = 4.0
        self.settings.style.buttonBarHeight = 52.0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.buttonBarItemTitleColor = .black
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
    }

    func configureViewModel() {
        self.viewModel.onFailure = { [weak self] in
            self?.showError(withMessage: $0.message)
        }
        self.viewModel.onTransactionRequestScanned = { [weak self] transactionRequest in
            guard let self = self else { return }
            self.performSegue(withIdentifier: self.transactionRequestDetailSegueIdentifier, sender: transactionRequest)
        }
        self.viewModel.onBarButtonNotificationToggle = { [weak self] in
            guard let self = self else { return }
            self.moveToViewController(at: (self.currentIndex + 1) % 2)
        }
        self.viewModel.onCameraPermissionDeclined = { [weak self] in
            guard let self = self else { return }
            // The first time the scanner is displayed, it'll load the camera view with a black window pending for camera permission.
            // If the permission is declined, we need to reload the pager so that it'll load the
            // ScannerNotAvailableViewController instead of the scanner.
            self.reloadPagerTabStripView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.transactionRequestDetailSegueIdentifier,
            let request = sender as? TransactionRequest,
            let transactionConfirmationVC = segue.destination as? TransactionConfirmationViewController {
            transactionConfirmationVC.viewModel = TransactionConfirmationViewModel(transactionRequest: request)
        }
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for _: PagerTabStripViewController) -> [UIViewController] {
        guard let qrViewController = QRViewController.initWithViewModel(self.qrViewModel) else { return [] }
        if let scannerViewController = self.viewModel.prepareScanner() {
            return [qrViewController, scannerViewController]
        } else if let scannerNotAvailableVC: ScannerNotAvailableViewController = Storyboard.qrCode.viewControllerFromId() {
            return [qrViewController, scannerNotAvailableVC]
        } else {
            return []
        }
    }

    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
        super.configureCell(cell, indicatorInfo: indicatorInfo)
        cell.backgroundColor = .clear
    }
}

extension QRViewController: IndicatorInfoProvider {
    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo: IndicatorInfo = IndicatorInfo(title: "qr_pager.my_qr".localized())
        return itemInfo
    }
}

extension QRScannerViewController: IndicatorInfoProvider {
    public func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo: IndicatorInfo = IndicatorInfo(title: "qr_pager.scan".localized())
        return itemInfo
    }
}

extension ScannerNotAvailableViewController: IndicatorInfoProvider {
    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo: IndicatorInfo = IndicatorInfo(title: "qr_pager.scan".localized())
        return itemInfo
    }
}
