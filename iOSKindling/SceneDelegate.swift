//
//  SceneDelegate.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-08.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

var store = Store()
var PreviewContext = Preview()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

		let contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(store)

		if let windowScene = scene as? UIWindowScene {
		    let window = UIWindow(windowScene: windowScene)
		    window.rootViewController = UIHostingController(rootView: contentView)
		    self.window = window
		    window.makeKeyAndVisible()
			DispatchQueue.main.async { AddKindleBooks(to: context) }
		}
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		try! (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
	}

}

