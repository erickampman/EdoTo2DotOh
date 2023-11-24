//
//  SaveFileView.swift
//  EdoTo2DotOh
//
//  Created by Eric Kampman on 11/23/23.
//

import SwiftUI

//struct SaveFileView: View {
import UniformTypeIdentifiers
struct DocumentPickerView: UIViewControllerRepresentable {
	func makeUIViewController(context: Context) -> some UIViewController {
		let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.text], asCopy: true)
		return documentPicker
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		print(context)
	}
	
}
