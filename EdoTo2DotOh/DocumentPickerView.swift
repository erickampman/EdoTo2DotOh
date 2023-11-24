//
//  DocumentPicker.swift
//  ViewControllerTest
//
//  Created by Eric Kampman on 11/23/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
	var nameFragment: String
	
	@State var documentPicker: UIDocumentPickerViewController!
	
	init(_ nameFragment: String) {
		let path: URL = FileManager.default.temporaryDirectory
		let dURL = path.appendingPathComponent("test.tmp", conformingTo: UTType.text)
		
		documentPicker = UIDocumentPickerViewController(forExporting: [dURL], asCopy: true)
		self.nameFragment = nameFragment
	}
		
	func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
		
		documentPicker.delegate = context.coordinator
		return documentPicker
	}
	func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
	}
	
	mutating func setVC(_ vc:UIDocumentPickerViewController) {
		self.documentPicker = vc
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(vc: documentPicker, parent: self)
	}
	
	class Coordinator: NSObject, UIDocumentPickerDelegate {
		var parent: DocumentPickerView
		
		init(vc: UIDocumentPickerViewController, parent: DocumentPickerView) {
			self.parent = parent
			super.init()
			vc.delegate = self
		}
		func documentPicker(
			_ controller: UIDocumentPickerViewController,
			didPickDocumentsAt urls: [URL]
		) {
			print("\(urls[0])")
		}
		
		func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
			print("Cancelled")
		}
	}
}
