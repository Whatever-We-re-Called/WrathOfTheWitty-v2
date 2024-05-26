extends Node2D

@export_group("Teams")
@export var player_party: PartyInfo
@export var enemy_party: PartyInfo
@export_group("Other")
@export var player_party_character_roots: Array[Node2D]
@export var enemy_party_character_roots: Array[Node2D]
@export var select_ui: Control

@onready var camera = $Camera2D

var selected_enemy_index = 2
var player_characters: Array[BattleCharacter]
var enemy_characters: Array[BattleCharacter]

const BATTLE_CHARACTER = preload("res://battle/battle_character.tscn")


func _ready():
	_init_player_party()
	_init_enemy_party()


func _process(delta):
	if Input.is_action_just_pressed("left") and selected_enemy_index > 0:
		selected_enemy_index -= 1
		camera.update_position(enemy_characters[selected_enemy_index])
		select_ui.global_position = enemy_characters[selected_enemy_index].global_position + Vector2(-100, -100)
	if Input.is_action_just_pressed("right") and selected_enemy_index < 4:
		selected_enemy_index += 1
		camera.update_position(enemy_characters[selected_enemy_index])
		select_ui.global_position = enemy_characters[selected_enemy_index].global_position + Vector2(-100, -100)


func _update_camera_position():
	select_ui.position = enemy_party_character_roots[selected_enemy_index].position + Vector2(-100, -100)
	match selected_enemy_index:
		0:
			camera.position.x = -300
		2:
			camera.position.x = -200
		4:
			camera.position.x = 0
		6:
			camera.position.x = 200
		8:
			camera.position.x = 300


func _init_player_party():
	var player_party_size = player_party.characters.size()
	for i in range(player_party_size):
		var character_info = player_party.characters[i]
		
		var battle_character = BATTLE_CHARACTER.instantiate()
		var player_root = player_party_character_roots[_get_root_index(i + 1, player_party_size, 4)]
		
		player_root.add_child(battle_character)
		battle_character.init(character_info, Constants.FacingDirection.BACKWARD)
		var sprite_height = battle_character.texture.get_height()
		battle_character.global_position.y -= (sprite_height * character_info.texture_scale.y) / 2.0
		
		player_characters.append(battle_character)


func _init_enemy_party():
	var enemy_party_size = enemy_party.characters.size()
	for i in range(enemy_party_size):
		var character_info = enemy_party.characters[i]
		
		var battle_character = BATTLE_CHARACTER.instantiate()
		var enemy_root = enemy_party_character_roots[_get_root_index(i + 1, enemy_party_size, 5)]
		
		enemy_root.add_child(battle_character)
		battle_character.init(character_info, Constants.FacingDirection.FORWARD)
		var sprite_height = battle_character.texture.get_height()
		battle_character.global_position.y -= (sprite_height * character_info.texture_scale.y) / 2.0
		
		enemy_characters.append(battle_character)


func _get_root_index(number_on_team: int, team_size: int, max_size: int):
	return ((max_size - 1) - (team_size - 1)) + ((number_on_team * 2) - 2)
