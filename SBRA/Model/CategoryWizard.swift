//
//  CategoryWizard.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

/**
CategoryWizard manages the graph of questions and the outcomes of the wizard.
It can be extended which provide the different wizards available.
*/
struct CategoryWizard {
	
	var questions: [WizardQuestion] {
		let buildingCategoryQuestions = [
			"""
			Bestaat het gebouw waarin u wilt meten uit een betonnen bebouwing met metselwerk of gevelbekleding?\n
			Veel bebouwing na 1970 valt in deze categorie
			""",
			"Betreft de bebouwing een monument of beschermd stadsgezicht?",
			"""
			Bestaat het pand waarin u wilt meten uit gemetselde wanden?
			\nVeel bebouwing van voor 1970 valt in deze categorie
			""",
			"""
			Verkeert het pand in slechte bouwkundige staat?\n
			Zijn er bijvoorbeeld scheuren of kieren of andere schade aan het pand aanwezig
			""",
			"Betreft de bebouwing een monument of beschermd stadsgezicht?",
			"""
			Bestaat het pand uit een stalen skelet, glas als gevelbekleding, of hout?\n
			Bijvoorbeeld houten schuurtjes of kantoorgebouwen met grote glazen gevels
			"""
			].map { (string: String) -> [Substring] in
				return string.split(separator: "\n")
			}.map { (subString: [Substring]) -> WizardQuestion in
				var secondary: String?
				if subString.count > 1 {
					secondary = String(subString[1])
				}
				return WizardQuestion(text: String(subString[0]), secondaryText: secondary)
		}
		
		let buildingCategoryOutcomes = [
			"Het pand behoort tot categorie 1 van de SBR-A richtlijn",
			"Het pand behoort tot categorie 2 van de SBR-A richtlijn",
			"Het pand behoort tot categorie 3 van de SBR-A richtlijn"
			].map({WizardOutcome(text: $0)})
		
		buildingCategoryOutcomes[0].buildingCategory = BuildingCategory.category1
		buildingCategoryOutcomes[1].buildingCategory = BuildingCategory.category2
		buildingCategoryOutcomes[2].buildingCategory = BuildingCategory.category3
		
		let buildingCategoryFailureOutcomes = [
			"Er is geen kwalificatie voor het type bebouwing kunnen maken",
			"Het pand kan niet worden ingedeeld in een categorie van de SBR-A richtlijn"
			].map({WizardOutcome(text: $0, isPositive: false)})
		
		let vibrationCategoryQuestions = [
			"""
			Zijn de trillingen die u wilt meten afkomstig van één van de onderstaande bronnen:

			- Explosies
			- Botsingen
			- Het van hoogte legen van kraanbakken
			- Het met de kraan breken van beton\n- Storten van puin in een container(bak)
			""",
			"""
			Zijn de trillingen die u wilt meten afkomstig van één van de onderstaande bronnen:

			- Weg- of railverkeer
			- Heiwerkzaamheden
			- Het rijden van shovel en kranen
			""",
			"""
			Zijn de trillingen die u wilt meten afkomstig van één van de onderstaande bronnen:

			- Intrillen van damwanden
			- Trilwalsen en trilplaten
			"""
			].map({WizardQuestion(text: $0, secondaryText: nil)})
		
		let vibrationCategoryOutcomes = [
			"De trillingen zijn conform de SBR-A richtlijn geclassificeerd als \"kortdurende trillingen\"",
			"De trillingen zijn conform de SBR-A richtlijn geclassificeerd als \"herhaald kortdurende trillingen\"",
			"De trillingen zijn conform de SBR-A richtlijn geclassificeerd als \"continue trillingen\""
			].map({WizardOutcome(text: $0)})
		
		vibrationCategoryOutcomes[0].vibrationCategory = .shortDuration
		vibrationCategoryOutcomes[1].vibrationCategory = .repeatedShortDuration
		vibrationCategoryOutcomes[2].vibrationCategory = .continuous
		
		let sensitiveToVibrationsCategoryQuestions = [
			"Is het pand gefundeerd op houten funderingspalen of is het gebouw op staal gefundeerd?"
			].map({WizardQuestion(text: $0, secondaryText: nil)})
		
		let sensitiveToVibrationsCategoryOutcomes = [
			"Het pand is geclassificeerd als trillingsgevoelig conform de SBR-A richtlijn",
			"Het pand is geclassificeerd als niet trillingsgevoelig conform de SBR-A richtlijn"
			].map({WizardOutcome(text: $0)})
		
		sensitiveToVibrationsCategoryQuestions[0].positiveNext = sensitiveToVibrationsCategoryOutcomes[0]
		sensitiveToVibrationsCategoryQuestions[0].negativeNext = sensitiveToVibrationsCategoryOutcomes[1]
		
		sensitiveToVibrationsCategoryOutcomes[0].sensitiveToVibrations = true
		sensitiveToVibrationsCategoryOutcomes[1].sensitiveToVibrations = false
		
		buildingCategoryQuestions[0].positiveNext = buildingCategoryQuestions[1]
		buildingCategoryQuestions[0].negativeNext = buildingCategoryQuestions[2]
		buildingCategoryQuestions[1].positiveNext = buildingCategoryOutcomes[2]
		buildingCategoryQuestions[1].negativeNext = buildingCategoryOutcomes[0]
		buildingCategoryQuestions[2].positiveNext = buildingCategoryQuestions[3]
		buildingCategoryQuestions[2].negativeNext = buildingCategoryQuestions[5]
		buildingCategoryQuestions[4].positiveNext = buildingCategoryOutcomes[2]
		buildingCategoryQuestions[4].negativeNext = buildingCategoryOutcomes[1]
		buildingCategoryQuestions[3].positiveNext = buildingCategoryOutcomes[2]
		buildingCategoryQuestions[3].negativeNext = buildingCategoryQuestions[4]
		buildingCategoryQuestions[5].positiveNext = buildingCategoryFailureOutcomes[1]
		buildingCategoryQuestions[5].negativeNext = buildingCategoryFailureOutcomes[0]
		
		/*
		-- Useful for testing the flow --
		for element in buildingCategoryQuestions {
		print("\(element.text) yes -> \(element.positiveNext?.text ?? nil)")
		print("\(element.text) no -> \(element.negativeNext?.text ?? nil)")
		}*/
		
		buildingCategoryOutcomes[0].next = vibrationCategoryQuestions[0]
		buildingCategoryOutcomes[1].next = vibrationCategoryQuestions[0]
		buildingCategoryOutcomes[2].next = vibrationCategoryQuestions[0]
		
		vibrationCategoryQuestions[0].positiveNext = vibrationCategoryOutcomes[0]
		vibrationCategoryQuestions[0].negativeNext = vibrationCategoryQuestions[1]
		vibrationCategoryQuestions[1].positiveNext = vibrationCategoryOutcomes[1]
		vibrationCategoryQuestions[1].negativeNext = vibrationCategoryQuestions[2]
		vibrationCategoryQuestions[2].positiveNext = vibrationCategoryOutcomes[2]
		let text = "Er is geen kwalificatie van het type trilling kunnen maken"
		vibrationCategoryQuestions[2].negativeNext = WizardOutcome(text: text,
																   isPositive: false)
		vibrationCategoryOutcomes[0].next = sensitiveToVibrationsCategoryQuestions[0]
		vibrationCategoryOutcomes[1].next = sensitiveToVibrationsCategoryQuestions[0]
		vibrationCategoryOutcomes[2].next = sensitiveToVibrationsCategoryQuestions[0]
		
		return buildingCategoryQuestions
	}
}
