//
//  BaseViewController.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    public var serviceProvider: ServiceProvider?
    public var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print(#function)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
        fatalError("init(coder:) has not been implemented")
    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    } 
}
