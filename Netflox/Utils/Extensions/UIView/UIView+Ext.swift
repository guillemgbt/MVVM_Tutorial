//
//  UIView+Ext.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 2/25/21. (actually Jeff :P)
//

import UIKit

extension UIView {

    func pin(inside container: UIView, with insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        pin(inside: container, insets: insets, isToSafeArea: false)
    }

    /// Adds the receiver to `container`'s view hierarchy and uses autolayout constraints to pin the
    /// receiver to the leading, trailing, top, and bottom anchors.
    ///
    /// - Parameter container: The view in which to add the receiver to
    /// - Parameter insets: The addintional insets for the pinned view.  These will be added to the safeAreaInsets if `isToSafeArea` is true.
    /// - Parameter isToSafeArea: if true the reciever is pinned to the containers safe area; if false it is constrained to the superview's outer edges.
    @objc(pinInsideView:insets:isToSafeArea:)
    func pin(inside container: UIView, insets: UIEdgeInsets, isToSafeArea: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        let layoutContainer: Constrainable = isToSafeArea ? container.safeAreaLayoutGuide : container
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: layoutContainer.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: layoutContainer.trailingAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: layoutContainer.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: layoutContainer.bottomAnchor, constant: -insets.bottom)
        ])
    }
}

/// A protocol which defines all view and safe area layout guide anchors which can be used for constraints
protocol Constrainable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var widthAnchor: NSLayoutDimension { get }
}

extension UIView: Constrainable {}
extension UILayoutGuide: Constrainable {}

public protocol Constructable where Self: UIView {}

// MARK: - Default Implementation
public extension Constructable {

    /// Creates, configures, and returns an instance of the receiver. The initialization method
    /// used to create an instance of the receiver is the `init()` method.
    ///
    /// - Parameter configureBlock: The closure that sets up the instance of the receiver created
    ///   by this method. The instance is passed into the closure so that it can be modified.
    /// - Returns: The configured instance of the receiver.
    static func construct(configureBlock: (Self) -> Void) -> Self {
        let value = self.init()
        configureBlock(value)
        return value
    }
}

// MARK: - UIView
extension UIView: Constructable {}
