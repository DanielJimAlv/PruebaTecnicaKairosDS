//
//  UITableView+Extension.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 24/11/21.
//

import UIKit

extension UITableView {
    private struct AssociatedKeys {
        static var numberOfSectios: Int = 0
    }
    
    var numberOfSections: Int {
        get {
            guard let result = objc_getAssociatedObject(self, &AssociatedKeys.numberOfSectios) as? Int else {
                return 1
            }
            return result + 1
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.numberOfSectios, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func isLoadingSection(_ section: Int) -> Bool {
        section == numberOfSections - 1
    }
    
    func getLoadingCell(with block: @escaping () -> Void) -> UITableViewCell {
        DispatchQueue.global(qos: .background).async {
            block()
        }
        
        return createLoadingTableViewCell()
    }
    
    private func createLoadingTableViewCell() -> UITableViewCell {
        let result = UITableViewCell()
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        result.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: result.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: result.centerYAnchor).isActive = true
        
        return result
    }
}
