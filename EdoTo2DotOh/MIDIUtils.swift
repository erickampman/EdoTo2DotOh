//
//  MIDIUtils.swift
//  EDOMaker
//
//  Created by Eric Kampman on 11/18/23.
//

import Foundation
import SwiftUI
import SwiftData

let firstOctaveFrequencies = [
	8.176,		// C-1, midi note 0
	8.662,
	9.177,
	9.723,
	10.301,
	10.913,
	11.562,
	12.250,
	12.978,
	13.750,
	14.568,
	15.434,
]


func semitoneRoots() -> [Double] {
	var ret = [Double]()
	
	let divisor = 512.0 * Double(12.0)  // always relative to 12 EDO semitones
	
	let root0 = pow(2, 1.0/divisor)
	var cumulative = Double(1.0)
	ret.append(cumulative)
	for i in 1..<512 {
		cumulative *= root0
		ret.append(cumulative)
	}
	
	return ret
}

let MIN = 0.005
func closeEnough(delta: Double) -> Bool { abs(delta) < MIN }

// needs more error checking.
//Returns note number and frequency diff between freq and note at note number
func nearestMIDINote(_ freq: Double) -> Int
{
	for i in 0...127 {
		let delta = midiFrequencies[i] - freq
		
		if closeEnough(delta: delta) {
			return i
		}
		/*
		  Probably a better way to handle this.
		  If delta is negative then sCloseEnough should break us out
		  If delta is positive then delta has to be bigger than .001
		 */
		if delta < 0 {
			continue
		}
		return i-1
	}
	return -1
}

#if false
func nearestMIDI512th(_ freq: Double, note: Int) -> Int
{
	let baseFreq = midiFrequencies[note]
	
	for i in 0..<512 {
		let fract = pow(2.0, Double(i)/512.0) - 1.0
		let curFreq = baseFreq + fract
		let delta = freq - curFreq
		
		if (closeEnough(delta: delta)) {
			return i
		}
		if delta > MIN { // errors get big enough to matter
			continue
		}
		return i - 1
	}
	return -1
}
#endif

func nearestMIDI512th(_ freq: Double, note: Int, roots: [Double]) -> Int
{
	let baseFreq = midiFrequencies[note]
	
	for i in 0..<512 {
		let val = baseFreq * roots[i]
		if closeEnough(delta: val - freq) {
			return i
		}
		if val > freq {
			return i
		}
	}
	
	return -1
}


// note in common based on 12 EDO (e.g. C4 is 60
// octavsAbove can be negative (means below noteInCommon
func frequencyFor(noteInCommon: Int, notesPerOctave: Int, octavesAbove: Int, noteInOctave: Int) -> Double{
	var baseOctaveFrequency = midiFrequencies[noteInCommon]   // midi numbers
	baseOctaveFrequency *= pow(2.0, Double(octavesAbove))
	
	return baseOctaveFrequency * pow(2.0, Double(noteInOctave)/Double(notesPerOctave))
}

struct FrequencyOctaveNote: Identifiable {
	@Attribute(.unique) let id: Double
//	let octave: Int
	let note: Int
	let fraction512: Int
	
	init(id: Double, note: Int, fraction512: Int) {
		self.id = id
		self.note = note
		self.fraction512 = fraction512
	}
}
extension FrequencyOctaveNote {
	var frequency: Double {
		return self.id
	}
	
	var description: String {
		return String("\(frequency),\(note),\(fraction512)")
	}
}

//func makeArray(noteInCommon: Int, notesPerOctave: Int, startingOctave: Int, octaveCount: Int) -> [FrequencyOctaveNote]
func makeArray(noteInCommon: Int, notesPerOctave: Int, startingOctave: Int) -> [FrequencyOctaveNote]
{
	var ret = [FrequencyOctaveNote]()
	let startingMIDINote = noteInCommon + startingOctave * 12
	let maxOctaves = 8
	var breakOut = false
	
	for octave in 0..<maxOctaves {  // test for last midi note in inner loop
		if breakOut { break }
	inner: for note in 0..<notesPerOctave {
			let f = frequencyFor(noteInCommon: startingMIDINote, notesPerOctave: notesPerOctave, octavesAbove: octave, noteInOctave: note)
			if (f > midiFrequencies[127]) {
				if (!closeEnough(delta: f - midiFrequencies[127])) {
					breakOut = true
					break inner;
				}
			}
			let nearestNote = nearestMIDINote(f)
			let fraction512 = nearestMIDI512th(f, note: nearestNote, roots: gRoots512)
			ret.append(FrequencyOctaveNote(id: f, note: nearestNote, fraction512: fraction512))
		}
	}
	return ret
}
