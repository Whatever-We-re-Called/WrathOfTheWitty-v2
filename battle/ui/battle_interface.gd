extends Control

@onready var selected_character_info_ui = %SelectedCharacterInfoUI
@onready var selected_character_name_label = %SelectedCharacterNameLabel
@onready var selected_character_insecurity_affinities_container = %SelectedCharacterInsecurityAffinitiesContainer
@onready var player_character_info_container = %PlayerCharacterInfoContainer
@onready var selected_character_insecurity_affinities_root = %SelectedCharacterInsecurityAffinitiesRoot
@onready var choose_ability_ui = %ChooseAbilityUI
@onready var ability_container = %AbilityContainer
@onready var ability_description_label = %AbilityDescriptionLabel
@onready var target_label = %TargetLabel
@onready var scroll_label = %ScrollLabel
@onready var confirm_label = %ConfirmLabel
@onready var view_info_label = %ViewInfoLabel
@onready var choose_ability_label = %ChooseAbilityLabel
@onready var view_bag_label = %ViewBagLabel
@onready var back_label = %BackLabel
@onready var end_turn_label = %EndTurnLabel
@onready var mana_value_label = %ManaValueLabel

const PLAYER_CHARACTER_INFO_UI = preload("res://battle/ui/player_character_info_ui.tscn")
const ABILITY_UI = preload("res://characters/abilities/textures/ability_ui.tscn")

func update_selected_character_info(battle_character: BattleCharacter):
	if battle_character == null:
		selected_character_info_ui.visible = false
	else:
		selected_character_info_ui.visible = true
		
		var character_info = battle_character.character_info
		selected_character_name_label.text = character_info.name
		
		for child in selected_character_insecurity_affinities_container.get_children():
			child.free()
		
		var insecurity_affinities: Dictionary
		insecurity_affinities[Constants.get_insecurity_icon(Constants.InsecurityAffinityType.WEAK)] = character_info.insecurity_weaknesses
		insecurity_affinities[Constants.get_insecurity_icon(Constants.InsecurityAffinityType.STRONG)] = character_info.insecurity_strengths
		insecurity_affinities[Constants.get_insecurity_icon(Constants.InsecurityAffinityType.BLOCK)] = character_info.insecurity_blocks
		insecurity_affinities[Constants.get_insecurity_icon(Constants.InsecurityAffinityType.DEFLECT)] = character_info.insecurity_deflects
		insecurity_affinities[Constants.get_insecurity_icon(Constants.InsecurityAffinityType.HEAL)] = character_info.insecurity_heals
		var display_insecurity_affinities = false
		selected_character_insecurity_affinities_root.visible = true
		for insecurity_affinity in insecurity_affinities:
			for insecurity in insecurity_affinities[insecurity_affinity]:
				var texture_rect = _get_insecurity_texture_rect(insecurity_affinity, Constants.get_insecurity_color(insecurity))
				selected_character_insecurity_affinities_container.add_child(texture_rect)
				display_insecurity_affinities = true
		selected_character_insecurity_affinities_root.visible = display_insecurity_affinities

func _get_insecurity_texture_rect(texture: Texture2D, color: Color) -> TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = Vector2(48, 48)
	texture_rect.modulate = color
	return texture_rect


func update_player_character_info(player_battle_characters: Array[BattleCharacter]):
	for child in player_character_info_container.get_children():
		child.free()
	
	for battle_character in player_battle_characters:
		var player_character_info_ui = PLAYER_CHARACTER_INFO_UI.instantiate()
		player_character_info_container.add_child(player_character_info_ui)
		player_character_info_ui.init(battle_character)


func set_choose_ability_ui_visibility(is_visible: bool):
	choose_ability_ui.visible = is_visible


func update_choose_ability_ui(selected_index: int, party_selections: PartySelections, current_mana: int):
	for child in ability_container.get_children():
		child.queue_free()
	
	var selected_player_character = party_selections.get_selected_player_character()
	var selected_enemy_character = party_selections.get_selected_enemy_character()
	for i in range(selected_player_character.character_info.abilities.size()):
		var ability_ui = ABILITY_UI.instantiate()
		ability_container.add_child(ability_ui)
		var ability = selected_player_character.character_info.abilities[i]
		var is_selected = i == selected_index
		ability_ui.init(selected_player_character, selected_enemy_character, ability, i, selected_index, current_mana)
	
	ability_description_label.text = selected_player_character.character_info.abilities[selected_index].description


func update_mana_ui(mana_value: int):
	mana_value_label.text = str(mana_value)


func reset_controls_ui():
	target_label.visible = false
	scroll_label.visible = false
	confirm_label.visible = false
	view_info_label.visible = false
	choose_ability_label.visible = false
	view_bag_label.visible = false
	back_label.visible = false
	end_turn_label.visible = false
