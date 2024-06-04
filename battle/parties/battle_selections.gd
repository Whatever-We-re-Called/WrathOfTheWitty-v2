class_name BattleSelections extends Node

signal updated_selected_character(selected_character: BattleCharacter)

class BattleSelectionData:
	var is_player_party = false
	var is_selected = false
	var selected_index = 0
	var is_targeted = false
	var targeted_index = 0
	var is_self_targeted = false
	var self_targeted_index = 0

var battle_selection_data: Dictionary
var battle: Battle


func init(battle: Battle):
	battle_selection_data[battle.player_characters] = BattleSelectionData.new()
	battle_selection_data[battle.player_characters].is_player_party = true
	battle_selection_data[battle.enemy_characters] = BattleSelectionData.new()
	self.battle = battle


func update_selected_index(characters: Array[BattleCharacter], index_change: int):
	var current_index = battle_selection_data[characters].selected_index
	set_selected_index(characters, current_index + index_change)


func set_selected_index(characters: Array[BattleCharacter], index: int):
	var clamped_index = index % characters.size()
	battle_selection_data[characters].selected_index = clamped_index
	updated_selected_character.emit(characters[clamped_index])


func get_selected_index(characters: Array[BattleCharacter]) -> int:
	return battle_selection_data[characters].selected_index


func set_is_selected(characters: Array[BattleCharacter], value: bool):
	battle_selection_data[characters].is_selected = value


func get_selected_player_character() -> BattleCharacter:
	var index = battle_selection_data[battle.player_characters].selected_index
	return battle.player_characters[index]


func get_selected_enemy_character() -> BattleCharacter:
	var index = battle_selection_data[battle.enemy_characters].selected_index
	return battle.enemy_characters[index]


func update_targeted_index(characters: Array[BattleCharacter], index_change: int):
	var current_index = battle_selection_data[characters].targeted_index
	set_targeted_index(characters, current_index + index_change)


func set_targeted_index(characters: Array[BattleCharacter], index: int):
	var clamped_index = index % characters.size()
	battle_selection_data[characters].targeted_index = clamped_index
	updated_selected_character.emit(characters[clamped_index])


func get_targeted_index(characters: Array[BattleCharacter]) -> int:
	return battle_selection_data[characters].targeted_index


func set_is_targeted(characters: Array[BattleCharacter], value: bool):
	battle_selection_data[characters].is_targeted = value


func get_targeted_player_character() -> BattleCharacter:
	var index = battle_selection_data[battle.player_characters].targeted_index
	return battle.player_characters[index]


func get_targeted_enemy_character() -> BattleCharacter:
	var index = battle_selection_data[battle.enemy_characters].targeted_index
	return battle.enemy_characters[index]


func update_ui(characters: Array[BattleCharacter], show_selected: bool, show_targeted: bool, show_self_targeted: bool):
	var selection_data = battle_selection_data[characters]
	
	for i in range(characters.size()):
		var character = characters[i]
		if show_selected and selection_data.selected_index == i:
			if selection_data.is_selected:
				if selection_data.is_player_party:
					character.set_drop_shadow(Constants.CharacterSelectState.PLAYER_SELECTED)
				else:
					character.set_drop_shadow(Constants.CharacterSelectState.ENEMY_SELECTED)
			else:
				if selection_data.is_player_party:
					character.set_drop_shadow(Constants.CharacterSelectState.PLAYER_SELECT)
				else:
					character.set_drop_shadow(Constants.CharacterSelectState.ENEMY_SELECT)
		elif show_targeted and selection_data.targeted_index == i:
			if selection_data.is_targeted:
				if selection_data.is_player_party:
					character.set_drop_shadow(Constants.CharacterSelectState.PLAYER_TARGETED)
				else:
					character.set_drop_shadow(Constants.CharacterSelectState.ENEMY_TARGETED)
			else:
				if selection_data.is_player_party:
					character.set_drop_shadow(Constants.CharacterSelectState.PLAYER_TARGET)
				else:
					character.set_drop_shadow(Constants.CharacterSelectState.ENEMY_TARGET)
		else:
			character.set_drop_shadow(Constants.CharacterSelectState.NONE)
		
		if selection_data.is_player_party:
			character.update_selected_tags(battle.get_current_selected_abilities(), get_selected_enemy_character())
		else:
			character.update_selected_tags(battle.get_current_selected_abilities(), get_selected_player_character())
