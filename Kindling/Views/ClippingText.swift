//
//  Clipping.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct ClippingText: View {
	var clipping: Clipping
	var body: some View {
		let header = clipping.page != 0 ? "PAGE \(clipping.page)" : "UNKNOWN PAGE"
		return VStack (alignment: .leading){
			Text(header)
				.fontWeight(.semibold)
				.foregroundColor(.secondary)
				.font(.caption)

			Text(clipping.withLeadingCapital())
					.lineLimit(nil)
					.font(.system(.body, design: .serif))
					.lineSpacing(2)
			
		}.padding()
	}
}

struct ClippingText_Previews: PreviewProvider {
	static var previews: some View {
		ClippingText(clipping: PreviewContext.book.clippings.first!)
	}
}
