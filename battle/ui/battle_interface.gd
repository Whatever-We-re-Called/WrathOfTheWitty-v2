extends Control

@onready var player_character_info_container = %PlayerCharacterInfoContainer

const PLAYER_CHARACTER_INFO_UI = preload("res://battle/ui/player_character_info_ui.tscn")


func update_player_character_info(player_battle_characters: Array[BattleCharacter]):
	for child in player_character_info_container.get_children():
		child.queue_free()
	
	for battle_character in player_battle_characters:
		var player_character_info_ui = PLAYER_CHARACTER_INFO_UI.instantiate()
		player_character_info_container.add_child(player_character_info_ui)
		player_character_info_ui.init(battle_character)
