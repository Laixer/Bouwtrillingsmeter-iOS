//
//  CategoryWizard.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

/**
CategoryWizard manages the graph of questions and the outcomes of the wizard. It can be extended which provide the different wizards available.
*/
struct CategoryWizard {
	var questions = [WizardQuestion]()
}

extension CategoryWizard {
	private func setupQuestions() {
		let questions = [
			"Bestaat het gebouw waarin u wilt meten uit een betonnen bebouwing met metselwerk of gevelbekleding?\nVeel bebouwing na 1970 valt in deze categorie",
			"Betreft de bebouwing een monument of beschermd stadsgezicht?",
			"Bestaat het pand waarin u wilt meten uit gemetselde wanden?\nVeel bebouwing van voor 1970 valt in deze categorie",
			"Betreft de bebouwing een monument of beschermd stadsgezicht?",
			"Verkeert het pand in slechte bouwkundige staat?\nZijn er bijvoorbeeld scheuren of kieren of andere schade aan het pand aanwezig",
			"Bestaat het pand uit een stalen skelet, glas als gevelbekleding, of hout?"
		].map { (s: String) -> [Substring] in
			return s.split(separator: "\n")
		}.map { (s: [Substring]) -> WizardQuestion in
			var secondary: String? = nil
			if s.count > 1 {
				secondary = String(s[1])
			}
			return WizardQuestion(text: String(s[0]), secondaryText: secondary, positiveNext: nil, negativeNext: nil)
		}
		
		let outcomes = [
			"Het pand behoort tot categorie 1 van de SBR-A richtlijn",
			"Het pand behoort tot categorie 2 van de SBR-A richtlijn",
			"Het pand behoort tot categorie 3 van de SBR-A richtlijn"
		].map({WizardOutcome(text: $0)})
		
		let failureOutcomes = [
			"Er is geen kwalificatie voor het type bebouwing kunnen maken",
			"Het pand kan niet worden ingedeeld in een categorie van de SBR-A richtlijn"
		].map({WizardOutcome(text: $0, isPositive: false)})
		
		questions[0].positiveNext = questions[1]
		questions[0].negativeNext = questions[2]
		questions[1].positiveNext = outcomes[2]
		questions[1].negativeNext = outcomes[0]
		questions[2].positiveNext = questions[3]
		questions[2].negativeNext = questions[5]
		questions[3].positiveNext = outcomes[2]
		questions[3].negativeNext = questions[4]
		questions[4].positiveNext = outcomes[2]
		questions[4].negativeNext = outcomes[1]
		questions[5].positiveNext = failureOutcomes[1]
		questions[5].negativeNext = failureOutcomes[0]
		
		
		
		
		
	}
	
}


