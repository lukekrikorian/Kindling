//
//  ContentView.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var store: Store
	@FetchRequest(fetchRequest: Book.request()) var books: FetchedResults<Book>

	func pickFirstSelection() {
		if books.count > 0 {
			store.selectedBook = books[0]
		}
	}

	var body: some View {
		return NavigationView {
			NavigationMaster(books: books.reversed())
			if self.store.selectedBook != nil {
				BookDetail(Book: self.store.selectedBook!)
			}
		}.onAppear(perform: self.pickFirstSelection)
	}
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
// }
