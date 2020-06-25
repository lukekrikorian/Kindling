//
//  BookRow.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import URLImage

struct BookRow: View {
	var Book: Book
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				HStack(alignment: .center) {
					URLImage(URL(string: self.Book.coverURL!)!, placeholder: { _ in
						Color.clear
							.frame(width: 70, height: 100)
					}) { proxy in
						proxy.image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.cornerRadius(3)
							.saturation(0.9)
							.frame(width: 45)
					}
					VStack(alignment: .leading) {
						Text(Book.title!.components(separatedBy: ":")[0])
							.font(.subheadline)
							.fontWeight(.semibold)
							.lineLimit(2)
						Text(Book.author!)
							.font(.subheadline)
							.lineLimit(1)
					}
				}
			}
			Spacer()
		}
		.padding([.top, .bottom], 10)
		.contextMenu {
			Button(action: self.deleteBook) {
				Text("Delete Book")
					.foregroundColor(Color.red)
			}
		}
	}

	func deleteBook() {
		var fetchRequest = NSFetchRequest<Book>(entityName: "Book")
		fetchRequest.predicate = NSPredicate(format: "id = %@", self.Book.id! as CVarArg)
		do {
			let books = try context.fetch(fetchRequest)
			context.delete(books.first!)
		} catch {
			print(error)
		}
	}
}

// struct BookRow_Previews: PreviewProvider {
//    static var previews: some View {
//        BookRow(book: nil).frame(maxWidth: 300)
//    }
// }
