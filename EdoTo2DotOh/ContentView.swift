//
//  ContentView.swift
//  EdoTo2DotOh
//
//  Created by Eric Kampman on 11/18/23.
//

import SwiftUI


enum NotesIn12EDO: Int, CaseIterable, Identifiable, CustomStringConvertible {
	case C
	case CSharp
	case D
	case DSharp
	case E
	case F
	case FSharp
	case G
	case GSharp
	case A
	case ASharp
	case B

	var id: Self { self }
	
	var description: String {
		switch (self) {
		case .C:
			return "C"
		case .CSharp:
			return "C#"
		case .D:
			return "D"
		case .DSharp:
			return "Eb"
		case .E:
			return "E"
		case .F:
			return "F"
		case .FSharp:
			return "F#"
		case .G:
			return "G"
		case .GSharp:
			return "Ab"
		case .A:
			return "A"
		case .ASharp:
			return "Bb"
		case .B:
			return "B"
		}
	}
}



struct ContentView: View {
	@State var noteInCommonWith12EDO = NotesIn12EDO.A
	@State var notesPerOctave = Int(12)
	@State var startingOctave = Int(3)
	@State var mappings = [FrequencyOctaveNote]()
	@State var fileName = ""
	
	let octavesBelow = 4
	let octaveCount = 9

    var body: some View {
		NavigationView {
			Form() {
				Section(header: Text("EDO to MIDI 2.0 7.9 Conversion")) {
					Picker("Note in Common With 12-EDO", selection: $noteInCommonWith12EDO) {
						ForEach(NotesIn12EDO.allCases) { note in
							Text(String(describing: note))
						}
					}
					Picker("Starting Octave", selection: $startingOctave) {
						ForEach(0..<8) { octave in
							Text("\(octave)")
						}
					}
//					HStack {
//						Text("Note in Common (0-127):")
//						TextField("Note in Common", value: $noteInCommon, formatter: NumberFormatter())
//							.frame(width: 100)
//							.border(.black)
//					}
					
					HStack() {
						Text("Notes per Octave (5-72):")
						Spacer()
						TextField("Notes per Octave", value: $notesPerOctave, formatter: NumberFormatter())
							.frame(width: 30)
							.border(.black)
					}
					
					HStack(alignment: .center) {
						Button("Calculate") {
							calculate()
						}
						if UIDevice.current.userInterfaceIdiom == .pad ||
						   UIDevice.current.userInterfaceIdiom == .mac
						{
							Button("Save Data") {
								saveData()
							}
							TextField("File Name", text: $fileName)
						}
						Spacer()
						NavigationLink("Display") {
							ResultsView(mappings: mappings)
						}
					}
				}
				
			}
			.border(.gray)
			.navigationTitle("EDO Calculator")
//			ScrollView {
//				ForEach(mappings) { mapping in
//					Text("\(mapping.frequency) - \(mapping.note) - \(mapping.fraction512)")
//						.padding([.leading, .trailing])
//				}
//			}
//			.border(.gray)
		}

    }
	
	func getDocumentsDirectory() -> URL {
		// HackingWithSwift
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	func saveData() {
		if fileName.isEmpty { return }
		if mappings.count == 0 { return }
		
		let fileNameTemp = String("\(fileName)-EDO(\(notesPerOctave))-Common(\(noteInCommonWith12EDO.description))")
		let baseDirectory = getDocumentsDirectory()
		let url = baseDirectory.appendingPathComponent(fileNameTemp, conformingTo: .text)
		
		var text = ""
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			do {
				for m in mappings {
					let item = String("\(m.description)\n")
					text.append(item)
				}
				try text.write(to: url, atomically: true, encoding: .utf8)
			}
			catch {
				print(error.localizedDescription)
			}
			
		}
		if UIDevice.current.userInterfaceIdiom == .mac {
			// choose file? LATER
			do {
				for m in mappings {
					let item = String("\(m.description)\n")
					text.append(item)
				}
				try text.write(to: url, atomically: true, encoding: .utf8)
			}
			catch {
				print(error.localizedDescription)
			}
		}

	}
	
	func calculate() {
		// number of notes is dependent on how many notes per octave. MIDI can represent 128 notes (0 - 127)
		
		let midiNotesTotal = Int(128)
//		let available = midiNotesTotal - noteInCommonWith12EDO.rawValue - startingOctave * 12
//		let octavesAvailable = available / notesPerOctave
		
		// first octave for MIDI is -1, so add 1 to startingOctave to compensate
		mappings = makeArray(noteInCommon: noteInCommonWith12EDO.rawValue, notesPerOctave: notesPerOctave, startingOctave: startingOctave+1)
		print(mappings)
	}
}


#Preview {
    ContentView()
}
