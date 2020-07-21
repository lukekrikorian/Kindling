//
//  ActivityView.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-09.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
	let items: [Any]

	func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
		return UIActivityViewController(activityItems: items, applicationActivities: nil)
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
