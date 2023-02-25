//
//  BaseCoordinator.swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import RxSwift
import UIKit

protocol Coordinator: AnyObject {}

public class BaseCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    internal let disposeBag = DisposeBag()

    // add only unique object
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard
            !childCoordinators.isEmpty,
            let coordinator = coordinator
        else { return }

        // Clear child-coordinators recursively
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators.forEach {
                coordinator.removeDependency($0)
            }
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    func start() {
        fatalError("Should be implemented by sub class.")
    }
}

