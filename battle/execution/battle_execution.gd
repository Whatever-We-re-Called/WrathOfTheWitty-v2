class_name BattleExecution

class BattleExecutionData:
	var ability: Ability
	var attacker_character: BattleCharacter
	var defender_character: BattleCharacter
	var battle_scene: BattleScene


static func try_to_execute(ability: Ability, attacker_character: BattleCharacter, defender_character: BattleCharacter, battle_scene: BattleScene):
	var battle_execution_data = BattleExecutionData.new()
	battle_execution_data.ability = ability
	battle_execution_data.attacker_character = attacker_character
	battle_execution_data.defender_character = defender_character
	battle_execution_data.battle_scene = battle_scene
	
	var execution_count = 1
	
	for i in range(execution_count):
		_execute(battle_execution_data)


static func _execute(battle_execution_data: BattleExecutionData):
	var regex = RegEx.new()
	regex.compile("[a-z,A-Z,0-9,_]*.tres")
	var file_name = regex.search(battle_execution_data.ability.resource_path).get_string()
	var execution_function_name = "_" + file_name.substr(0, file_name.length() - 5)
	
	var execute_callable = Callable(BattleExecution, execution_function_name)
	execute_callable.call(battle_execution_data)


static func _one_weak_appearance_attack(battle_execution_data: BattleExecutionData):
	battle_execution_data.defender_character.damage(5)


static func _one_normal_appearance_attack(battle_execution_data: BattleExecutionData):
	battle_execution_data.defender_character.damage(10)


static func _one_strong_appearance_attack(battle_execution_data: BattleExecutionData):
	battle_execution_data.defender_character.damage(20)
