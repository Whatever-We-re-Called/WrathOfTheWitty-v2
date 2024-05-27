extends Control

@onready var selected_character_info_ui = %SelectedCharacterInfoUI
@onready var selected_character_name_label = %SelectedCharacterNameLabel
@onready var selected_character_insecurity_affinities_container = %SelectedCharacterInsecurityAffinitiesContainer
@onready var player_character_info_container = %PlayerCharacterInfoContainer
@onready var selected_character_insecurity_affinities_root = %SelectedCharacterInsecurityAffinitiesRoot
@onready var choose_ability_ui = %ChooseAbilityUI
@onready var ability_container = %AbilityContainer
@onready var ability_description_label = %AbilityDescriptionLabel

var selected_ability_index = 0

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
			child.queue_free()
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
		child.queue_free()
	
	for battle_character in player_battle_characters:
		var player_character_info_ui = PLAYER_CHARACTER_INFO_UI.instantiate()
		player_character_info_container.add_child(player_character_info_ui)
		player_character_info_ui.init(battle_character)


func set_choose_ability_ui_visibility(is_visible: bool, character_info: CharacterInfo = null):
	if is_visible:
		choose_ability_ui.visible = true
		selected_ability_index = 0
		update_choose_ability_ui(character_info)
	else:
		choose_ability_ui.visible = false


func increase_chosen_ability_index(increment: int, character_info: CharacterInfo):
	selected_ability_index += increment
	if selected_ability_index > character_info.abilities.size() - 1:
		selected_ability_index = 0
	elif selected_ability_index < 0:
		selected_ability_index = character_info.abilities.size() - 1
	update_choose_ability_ui(character_info)


func update_choose_ability_ui(character_info: CharacterInfo):
	for child in ability_container.get_children():
		child.queue_free()
	
	for i in range(character_info.abilities.size()):
		var ability_ui = ABILITY_UI.instantiate()
		ability_container.add_child(ability_ui)
		print( i == selected_ability_index)
		ability_ui.init(character_info.abilities[i], i == selected_ability_index)
	
	ability_description_label.text = character_info.abilities[selected_ability_index].description
