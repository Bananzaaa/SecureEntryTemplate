//
//  PinViewController.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import UIKit

class PinViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var passwordView: PinView = {
        let passwordView: PinView = PinView.loadFromNib()
        passwordView.delegate = self
        return passwordView
    }()
    
    // MARK: - Private
    
    private var viewModel: PinViewModel?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        viewModel = PinViewModel(biometryAuthContext: BiometryAuthContext(),
                                 appSettingsService: AppSettings())
        configureViewModelOutput()
        viewModel?.input.updateAppearence()
    }
    
    // MARK: - ViewModel
    
    private func configureViewModelOutput() {

        viewModel?.output.errorDescription = { [weak self] description in
            self?.passwordView.setError(description)
        }
        
        viewModel?.output.isPinSetup = { [weak self] _ in
            let vc = DestinationViewController().embededInNavigationController()
            self?.present(vc, animated: true, completion: nil)
        }
        
        viewModel?.output.successAuth = { [weak self] in
            let vc = DestinationViewController().embededInNavigationController()
            self?.present(vc, animated: true, completion: nil)
        }
        
        viewModel?.output.titleDescription = { [weak self] title in
            self?.passwordView.setTitle(title)
        }
    }

    // MARK: - Helpful
    
    private func showExitAlert() {
        let alert = UIAlertController(title: "Are you want to exit from app?",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { _ in
            exit(0)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension PinViewController: PinViewDelegate {
    func numberButtonTapped(_ value: Int) {
        print(#function, value)
        viewModel?.input.enterDigit(value)
    }
    
    func deleteButtonTapped() {
        print(#function)
        viewModel?.input.deleteLastDigit()
    }
    
    func biometryButtonTapped() {
        print(#function)
        viewModel?.input.biometryAuthMethodChoosen()
    }
    
    func exitButtonTapped() {
        print(#function)
        showExitAlert()
    }

}

