//
//  EditSheet.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-25.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

//struct EditSheet: View {
//    @EnvironmentObject var store: Store
//    @Binding var EditModal: (show: Bool, clipping: Clipping)
//    var resetSidebar: () -> Void
//    @State private var editedText = ""
//
//    func saveChanges() {
//        var book = self.store.selectedBook!
//        var index = (
//            book: self.store.books.index(of: book)!,
//            clipping: book.clippings.index(of: self.EditModal.clipping)!
//        )
//        self.store.books[index.book].clippings[index.clipping] = book.clippings[index.clipping]
//        self.resetSidebar()
//        self.closeModal()
//    }
//
//    func getClippingIndex() -> Int {
//        return self.store.selectedBook!.clippings.index(of: self.EditModal.clipping)!
//    }
//    func closeModal() {
//        self.EditModal.show.toggle()
//    }
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Edit Highlight")
//                .font(.headline)
//                .padding([.top, .leading, .trailing])
//            MultiLineText(text: self.$EditModal.clipping, x: 360, y: 200).padding([.leading, .trailing])
//            HStack {
//                Button(action: self.saveChanges) { Text("Save") }
//                Button(action: self.closeModal) { Text("Cancel") }
//            }.padding([.leading, .trailing, .bottom ]).buttonStyle(BorderedButtonStyle())
//        }.frame(width: 400, height: 300).onAppear(perform: { self.EditModal.clipping})
//    }
//}
//
//struct EditSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSheet(Books: .constant(nil), EditModal: .constant((false, "")), SelectedBook: .constant(nil))
//    }
//}
