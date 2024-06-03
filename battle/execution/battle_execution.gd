class_name BattleExecution

class BattleExecutionData:
	var ability: Ability
	var attacker_character: BattleCharacter
	var defender_character: BattleCharacter
	var battle: Battle


static func try_to_execute(ability: Ability, attacker_character: BattleCharacter, defender_character: BattleCharacter, battle: Battle):
	var battle_execution_data = BattleExecutionData.new()
	battle_execution_data.ability = ability
	battle_execution_data.attacker_character = attacker_character
	battle_execution_data.defender_character = defender_character
	battle_execution_data.battle = battle
	
	var execution_count = 1
	
	for i in range(execution_count):
		_execute(battle_execution_data)


static func _execute(battle_execution_data: BattleExecutionData):
	var regex = RegEx.new()
	regex.compile("[a-z,A-Z,0-9,_]*.tres")
	var file_name = regex.search(battle_execution_data.ability.resource_path).get_string()
	var execution_function_name = "_" + file_name.substr(0, file_name.length() - 5)
	
	var attacker_character = battle_execution_data.attacker_character
	battle_execution_data.defender_character.update_depression(attacker_character, battle_execution_data.ability)
	
	var execute_callable = Callable(BattleExecution, execution_function_name)
	execute_callable.call(battle_execution_data)


static func _one_weak_appearance_attack(battle_execution_data: BattleExecutionData):
	_deal_damage(battle_execution_data, 5)


static func _one_normal_appearance_attack(battle_execution_data: BattleExecutionData):
	_deal_damage(battle_execution_data, 10)


static func _one_strong_appearance_attack(battle_execution_data: BattleExecutionData):
	_deal_damage(battle_execution_data, 20)


static func _deal_damage(battle_execution_data: BattleExecutionData, damage_dealt: int):
	var defender_character = battle_execution_data.defender_character
	
	# Depression multiplier
	var multiplier = 1.0
	multiplier += 0.25 * defender_character.get_depression_size()
	
	var final_damage_dealt = damage_dealt * multiplier
	defender_character.damage(final_damage_dealt)
	
	# TODO Remove debug
	var attacker_character = battle_execution_data.attacker_character
	print("Damage dealt: ", final_damage_dealt, " (Base: ", damage_dealt, ", Multiplier: ", multiplier, ")")
