//
//  BaseViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import RxSwift

public class BaseViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
