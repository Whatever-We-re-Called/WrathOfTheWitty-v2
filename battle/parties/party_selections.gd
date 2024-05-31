class_name PartySelections extends Node

signal updated_selected_character(battle_character: BattleCharacter, update_display: bool)

var player_character_selections: Dictionary
var enemy_character_selections: Dictionary
var camera: BattleCamera


func init(player_characters: Array[BattleCharacter], enemy_characters: Array[BattleCharacter], camera: BattleCamera):
	for player_character in player_characters:
		player_character_selections[player_character] = Constants.CharacterSelectState.NONE
	for enemy_character in enemy_characters:
		enemy_character_selections[enemy_character] = Constants.CharacterSelectState.NONE
	
	self.camera = camera


func reset():
	print("reset")
	for player_character_selection in player_character_selections:
		player_character_selection = Constants.CharacterSelectState.NONE
	for enemy_character_selection in enemy_character_selections:
		enemy_character_selection = Constants.CharacterSelectState.NONE


func update_selected_character_index(state: Constants.CharacterSelectState, index_change: int, update_display: bool = false):
	var checked_character_selections = _get_checked_character_selections(state)
	
	var previous_index = 0
	var check_index = 0
	for checked_character_selection in checked_character_selections:
		var value = checked_character_selections[checked_character_selection]
		if value != Constants.CharacterSelectState.NONE:
			previous_index = check_index
			value = Constants.CharacterSelectState.NONE
			break
		else:
			check_index += 1
	
	var new_index = previous_index + index_change
	var max_selections_index = checked_character_selections.size() - 1
	if new_index < 0: new_index = max_selections_index
	if new_index > max_selections_index: new_index = 0
	
	for i in range(checked_character_selections.size()):
		var battle_character = checked_character_selections.keys()[i]
		if i == new_index:
			checked_character_selections[battle_character] = state
			if update_display:
				updated_selected_character.emit(battle_character, update_display)
				camera.update_position(battle_character)
				battle_character.set_drop_shadow(state)
		else:
			checked_character_selections[battle_character] = Constants.CharacterSelectState.NONE
			if update_display:
				battle_character.set_drop_shadow(Constants.CharacterSelectState.NONE)


func hide_player_selected_state():
	for player_character_selection in player_character_selections:
		player_character_selection.set_drop_shadow(Constants.CharacterSelectState.NONE)


func hide_enemy_selected_state():
	for enemy_character_selection in enemy_character_selections:
		enemy_character_selection.set_drop_shadow(Constants.CharacterSelectState.NONE)


func get_selected_player_character() -> BattleCharacter:
	for player_character_selection in player_character_selections:
		if player_character_selections[player_character_selection] != Constants.CharacterSelectState.NONE:
			return player_character_selection
	return null

func get_selected_enemy_character() -> BattleCharacter:
	for enemy_character_selection in enemy_character_selections:
		if enemy_character_selections[enemy_character_selection] != Constants.CharacterSelectState.NONE:
			return enemy_character_selection
	return null


func _get_checked_character_selections(state: Constants.CharacterSelectState) -> Dictionary:
	match state:
		Constants.CharacterSelectState.PLAYER_SELECT:
			return player_character_selections
		Constants.CharacterSelectState.PLAYER_SELECTED:
			return player_character_selections
		Constants.CharacterSelectState.PLAYER_TARGET:
			return player_character_selections
		Constants.CharacterSelectState.PLAYER_TARGETED:
			return player_character_selections
		Constants.CharacterSelectState.ENEMY_SELECT:
			return enemy_character_selections
		Constants.CharacterSelectState.ENEMY_SELECTED:
			return enemy_character_selections
		Constants.CharacterSelectState.ENEMY_TARGET:
			return enemy_character_selections
		Constants.CharacterSelectState.ENEMY_TARGETED:
			return enemy_character_selections
	return player_character_selections
