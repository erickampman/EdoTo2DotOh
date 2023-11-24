//
//  DocumentPicker.swift
//  ViewControllerTest
//
//  Created by Eric Kampman on 11/23/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
	var data: [FrequencyOctaveNote]
	var documentPicker: UIDocumentPickerViewController!
	let tempFileName = "temp.txt"
	var jsonData = Data()
	
	init(data: [FrequencyOctaveNote]) {
		let path: URL = FileManager.default.temporaryDirectory
		let dURL = path.appendingPathComponent(tempFileName, conformingTo: UTType.text)
		self.data = data

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let json = try encoder.encode(data)
			jsonData = json
			
			try jsonData.write(to: dURL)
			
			self.documentPicker = UIDocumentPickerViewController(forExporting: [dURL], asCopy: true)

		} catch {
			fatalError("JSON save failed")
		}
		
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
		return Coordinator(vc: documentPicker, parent: self)
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
