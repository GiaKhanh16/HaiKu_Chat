func countSyllables(_ text: String) -> Int {
			// Handle empty or invalid input
	 guard !text.isEmpty else { return 0 }

			// Convert to lowercase and split into words
	 let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
	 var totalSyllables = 0

	 for word in words {
				 // Remove punctuation for cleaner processing
			let cleanWord = word.filter { $0.isLetter }
			if cleanWord.isEmpty { continue }

			var syllableCount = 0
			var previousIsVowel = false
			let vowels = Set("aeiouy")

				 // Iterate through characters
			for (index, char) in cleanWord.enumerated() {
				 let isVowel = vowels.contains(char)

						// Count vowel groups as syllables
				 if isVowel && !previousIsVowel {
						syllableCount += 1
				 }

						// Handle silent 'e' at the end
				 if index == cleanWord.count - 1 && char == "e" && syllableCount > 1 {
							 // Check if the character before 'e' is not a vowel
						if index > 0 {
							 let prevChar = cleanWord[cleanWord.index(cleanWord.startIndex, offsetBy: index - 1)]
							 if !vowels.contains(prevChar) {
									syllableCount -= 1
							 }
						}
				 }

				 previousIsVowel = isVowel
			}

				 // Handle diphthongs (simplified: reduce count for common pairs like "ai", "ou")
			let diphthongs = ["ai", "au", "oi", "ou", "ea", "ee", "oo", "ie"]
			for diphthong in diphthongs {
				 if cleanWord.contains(diphthong) {
						syllableCount -= cleanWord.components(separatedBy: diphthong).count - 1
				 }
			}

				 // Ensure at least one syllable per word
			syllableCount = max(syllableCount, 1)
			totalSyllables += syllableCount
	 }

	 return totalSyllables
}



