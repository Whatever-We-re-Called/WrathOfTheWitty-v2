class_name BattleExecution

class BattleExecutionData:
	var ability: Ability
	var attacker_character: BattleCharacter
	var defender_character: BattleCharacter
	var battle: Battle


static func try_to_execute(ability: Ability, attacker_character: BattleCharacter, defender_characters: Array[BattleCharacter], battle: Battle):
	var battle_execution_data = BattleExecutionData.new()
	battle_execution_data.ability = ability
	battle_execution_data.attacker_character = attacker_character
	battle_execution_data.battle = battle
	
	var execution_count = 1
	
	for defender_character in defender_characters:
		battle_execution_data.defender_character = defender_character
		for i in range(execution_count):
			_execute(battle_execution_data)


static func _execute(battle_execution_data: BattleExecutionData):
	var regex = RegEx.new()
	regex.compile("[a-z,A-Z,0-9,_]*.tres")
	var file_name = regex.search(battle_execution_data.ability.resource_path).get_string()
	var execution_function_name = "_" + file_name.substr(0, file_name.length() - 5)
	
	var execute_callable = Callable(BattleExecution, execution_function_name)
	execute_callable.call(battle_execution_data)
	


static func _one_appearance_attack(battle_execution_data: BattleExecutionData):
	var damage_dealt = battle_execution_data.ability.value
	_deal_damage(battle_execution_data, damage_dealt)
	_apply_effect(battle_execution_data, Constants.ActiveStatusEffect.FEAR)


static func _one_strong_appearance_attack(battle_execution_data: BattleExecutionData):
	var damage_dealt = battle_execution_data.ability.value
	_deal_damage(battle_execution_data, damage_dealt)
	_apply_effect(battle_execution_data, Constants.ActiveStatusEffect.FEAR)


static func _one_very_strong_appearance_attack(battle_execution_data: BattleExecutionData):
	var damage_dealt = battle_execution_data.ability.value
	_deal_damage(battle_execution_data, damage_dealt)
	_apply_effect(battle_execution_data, Constants.ActiveStatusEffect.FEAR)


static func _all_appearance_attack(battle_execution_data: BattleExecutionData):
	var damage_dealt = battle_execution_data.ability.value
	_deal_damage(battle_execution_data, damage_dealt)
	_apply_effect(battle_execution_data, Constants.ActiveStatusEffect.FEAR)


static func _all_strong_appearance_attack(battle_execution_data: BattleExecutionData):
	var damage_dealt = battle_execution_data.ability.value
	_deal_damage(battle_execution_data, damage_dealt)
	_apply_effect(battle_execution_data, Constants.ActiveStatusEffect.FEAR)


static func _deal_damage(battle_execution_data: BattleExecutionData, damage_dealt: int):
	var ability = battle_execution_data.ability
	var attacker_character = battle_execution_data.attacker_character
	var defender_character = battle_execution_data.defender_character
	
	var multiplier = 1.0
	var attack_land_type = Constants.AttackLandType.HIT
	
	var rng = RandomNumberGenerator.new()
	if rng.randf_range(0.0, 1.0) <= ability.attack_accuracy:
		var ability_insecurity = Constants.get_matching_insecurity_for_ability_type(battle_execution_data.ability.type)
		if defender_character.character_info.insecurity_weaknesses.has(ability_insecurity):
			if defender_character.get_depression_size() > 0 and not defender_character.is_character_a_depression_assaulter(attacker_character):
				attack_land_type = Constants.AttackLandType.CHAIN
				multiplier += 0.25 + (0.25 * defender_character.get_depression_size())
			else:
				attack_land_type = Constants.AttackLandType.WEAK
				multiplier += 0.25
		
		defender_character.update_depression(attacker_character, ability)
	else:
		attack_land_type = Constants.AttackLandType.MISS
		damage_dealt = 0
	
	# Apply Damage
	var final_damage_dealt = damage_dealt * multiplier
	defender_character.damage(final_damage_dealt, attack_land_type)
	
	# TODO Remove debug
	print("Damage dealt: ", final_damage_dealt, " (Base: ", damage_dealt, ", Multiplier: ", multiplier, ")")


static func _apply_effect(battle_execution_data: BattleExecutionData, status_effect: Constants.ActiveStatusEffect):
	var rng = RandomNumberGenerator.new()
	if rng.randf_range(0.0, 1.0) <= battle_execution_data.ability.effect_accuracy:
		var defender_player = battle_execution_data.defender_character
		defender_player.apply_status_effect(status_effect)
