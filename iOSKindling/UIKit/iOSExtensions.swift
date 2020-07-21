//
//  iOSExtensions.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import UIKit

extension NSNotification.Name {
	static public let deviceShake = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceShake, object: event)
    }
}
