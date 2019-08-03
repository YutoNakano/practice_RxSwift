//
//  ViewController.swift
//  practice_RxSimple
//
//  Created by 中野湧仁 on 2019/08/03.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    private lazy var viewModel = ViewModel(
        idTextObservable: idTextField.rx.text.asObservable(),
        passwordTextObservable: passwordTextField.rx.text.asObservable(),
        model: Model())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.validationText
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.loadLabelColor
            .bind(to: loadLabelColor)
            .disposed(by: disposeBag)
        
    }
    
    private var loadLabelColor: Binder<UIColor> {
        return Binder(self) { me, color in
            me.validationLabel.textColor = color
        }
    }


}

