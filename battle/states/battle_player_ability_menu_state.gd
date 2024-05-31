extends BattleState

var selected_ability_index: int
var character_info: CharacterInfo
var current_mana: int

func _enter():
	battle.battle_interface.set_choose_ability_ui_visibility(true)
	
	selected_ability_index = 0
	character_info = battle.party_selections.get_selected_player_character().character_info
	current_mana = battle.current_player_mana
	_update_ability_ui()


func _exit():
	battle.battle_interface.set_choose_ability_ui_visibility(false)


func _update():
	if Input.is_action_just_pressed("scroll_up"):
		_increase_chosen_ability_index(-1)
	if Input.is_action_just_pressed("scroll_down"):
		_increase_chosen_ability_index(1)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerIdle")
	if Input.is_action_just_pressed("confirm"):
		battle.current_player_selected_ability = character_info.abilities[selected_ability_index]
		battle.change_to_state("PlayerTarget")


func _increase_chosen_ability_index(increment: int):
	selected_ability_index += increment
	
	var max_abilities_index = character_info.abilities.size() - 1
	if selected_ability_index > max_abilities_index:
		selected_ability_index = 0
	elif selected_ability_index < 0:
		selected_ability_index = max_abilities_index
	
	if not _can_afford_selected_ability():
		_increase_chosen_ability_index(increment)
		return
	
	_update_ability_ui()


func _update_ability_ui():
	battle.battle_interface.update_choose_ability_ui(selected_ability_index, character_info, current_mana)


func _can_afford_selected_ability() -> bool:
	if selected_ability_index > character_info.abilities.size() - 1:
		return false
	elif selected_ability_index < 0:
		return false
	else:
		return current_mana >= character_info.abilities[selected_ability_index].mana_cost
