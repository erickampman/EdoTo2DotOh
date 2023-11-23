//
//  ResultsView.swift
//  EdoTo2DotOh
//
//  Created by Eric Kampman on 11/23/23.
//

import SwiftUI

struct ResultsView: View {
//	@Binding var mappings: [FrequencyOctaveNote]
	let mappings: [FrequencyOctaveNote]
 var body: some View {
		ScrollView {
			ForEach(mappings) { mapping in
				Text(verbatim: "\(mapping.frequency) - \(mapping.note) - \(mapping.fraction512)")
					.padding([.leading, .trailing])
			}
		}
		.border(.gray)
    }
}

//#Preview {
//	ResultsView(mappings: [FrequencyOctaveNote]())
//}
