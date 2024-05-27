class_name BattleScene extends Node2D

enum State { 
	PLAYER_SELECTING,
	PLAYER_IDLE,
	PLAYER_MENU,
	PLAYER_TARGETING,
	PLAYER_ATTACKING,
	ENEMY_ATTACKING
}

@export_group("Teams")
@export var player_party: PartyInfo
@export var enemy_party: PartyInfo
@export_group("Other")
@export var player_party_character_roots: Array[Node2D]
@export var enemy_party_character_roots: Array[Node2D]

@onready var camera = $Camera2D
@onready var battle_interface = $CanvasLayer/BattleInterface

var state: State
var selected_character_index = 0
var player_characters: Array[BattleCharacter]
var enemy_characters: Array[BattleCharacter]
var selectable_characters: Array[BattleCharacter]
var selected_character: BattleCharacter

const BATTLE_CHARACTER = preload("res://battle/battle_character/battle_character.tscn")


func _ready():
	_init_player_party()
	_init_enemy_party()
	
	state = State.PLAYER_SELECTING
	_set_selectable_characters(player_characters)
	_set_selected_character(0)
	
	camera.reset_smoothing()


func _process(delta):
	_handle_controls_and_state_routing()


func _handle_controls_and_state_routing():
	match state:
		State.PLAYER_SELECTING:
			if Input.is_action_just_pressed("target_left"):
				_update_selected_character(-1)
			if Input.is_action_just_pressed("target_right"):
				_update_selected_character(1)
			if Input.is_action_just_pressed("confirm"):
				set_state(State.PLAYER_IDLE)
				_set_selectable_characters(enemy_characters)
		State.PLAYER_IDLE:
			if Input.is_action_just_pressed("target_left"):
				_update_selected_character(-1)
			if Input.is_action_just_pressed("target_right"):
				_update_selected_character(1)
			if Input.is_action_just_pressed("back"):
				set_state(State.PLAYER_SELECTING)
				_set_selectable_characters(player_characters)
			if Input.is_action_just_pressed("choose_ability"):
				set_state(State.PLAYER_MENU)
				battle_interface.set_choose_ability_ui_visibility(true, player_characters[selected_character_index].character_info)
		State.PLAYER_MENU:
			if Input.is_action_just_pressed("scroll_up"):
				battle_interface.increase_chosen_ability_index(-1, player_characters[selected_character_index].character_info)
			if Input.is_action_just_pressed("scroll_down"):
				battle_interface.increase_chosen_ability_index(1, player_characters[selected_character_index].character_info)
			if Input.is_action_just_pressed("back"):
				set_state(State.PLAYER_IDLE)
				battle_interface.set_choose_ability_ui_visibility(false)
			


func _init_player_party():
	var player_party_size = player_party.characters.size()
	for i in range(player_party_size):
		var character_info = player_party.characters[i]
		
		var battle_character = BATTLE_CHARACTER.instantiate()
		var player_root = player_party_character_roots[_get_root_index(i + 1, player_party_size)]
		
		player_root.add_child(battle_character)
		var facing_direction: Constants.FacingDirection
		if i < player_party_size / 2:
			facing_direction = Constants.FacingDirection.BACKWARD_LEFT 
		else:
			facing_direction = Constants.FacingDirection.BACKWARD_RIGHT 
		battle_character.init(character_info, facing_direction)
		
		player_characters.append(battle_character)
	
	battle_interface.update_player_character_info(player_characters)


func _init_enemy_party():
	var enemy_party_size = enemy_party.characters.size()
	for i in range(enemy_party_size):
		var character_info = enemy_party.characters[i]
		
		var battle_character = BATTLE_CHARACTER.instantiate()
		var enemy_root = enemy_party_character_roots[_get_root_index(i + 1, enemy_party_size)]
		
		enemy_root.add_child(battle_character)
		var facing_direction: Constants.FacingDirection
		if i < enemy_party_size / 2:
			facing_direction = Constants.FacingDirection.FORWARD_LEFT 
		else:
			facing_direction = Constants.FacingDirection.FORWARD_RIGHT 
		battle_character.init(character_info, facing_direction)
		
		enemy_characters.append(battle_character)


func _get_root_index(number_on_team: int, team_size: int):
	return ((PartyInfo.MAX_SIZE - 1) - (team_size - 1)) + ((number_on_team * 2) - 2)


func _set_selectable_characters(new_selectable_characters: Array[BattleCharacter]):
	for selectable_character in selectable_characters:
		selectable_character.set_as_selected(false)
	
	# TODO Add logic for unselectable party members.
	var new_selected_index = lerp(0, new_selectable_characters.size() - 1, float(selected_character_index) / float(selectable_characters.size() - 1))
	selectable_characters = new_selectable_characters
	_set_selected_character(new_selected_index)


func _update_selected_character(index_change: int):
	_set_selected_character(selected_character_index + index_change)


func _set_selected_character(index: int):
	selected_character_index = index
	
	if selected_character_index < 0:
		selected_character_index = selectable_characters.size() - 1
	elif selected_character_index > selectable_characters.size() - 1:
		selected_character_index = 0
	
	selected_character = selectable_characters[selected_character_index]
	camera.update_position(selected_character)
	for selectable_character in selectable_characters:
		selectable_character.set_as_selected(selectable_character == selected_character, state != State.PLAYER_SELECTING)
	
	battle_interface.update_selected_character_info(selected_character)


func set_state(new_state: State):
	self.state = new_state
	battle_interface.update_controls_ui(new_state)
