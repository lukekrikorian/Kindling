//
//  Bridge.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#else
import Cocoa
let pasteboard = NSPasteboard.general
#endif

enum Platform {
	case iOS, macOS
}

class Bridge {
	var platform: Platform {
		#if os(iOS)
		return .iOS
		#else
		return .macOS
		#endif
	}
	
	func saveToClipboard(str: String) {
		#if os(iOS)
		UIPasteboard.general.string = str
		#else
		pasteboard.clearContents()
		pasteboard.writeObjects([str as NSString])
		#endif
	}
	
	func openURL(_ str: String) {
		if let url = URL(string: str) {
			#if os(iOS)
			UIApplication.shared.open(url)
			#else
			NSWorkspace.shared.open(url)
			#endif
		}
	}
}
