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

@onready var camera = $Camera2D
@onready var battle_interface = $CanvasLayer/BattleInterface
@onready var enemy_roots = $EnemyRoots
@onready var player_roots = $PlayerRoots

var player_party_character_roots: Array[Node2D]
var enemy_party_character_roots: Array[Node2D]
var state: State
var player_characters: Array[BattleCharacter]
var enemy_characters: Array[BattleCharacter]

class PartySelection:
	var selectable_characters: Array[BattleCharacter]
	var selected_index: int = 0
	
	func get_selected_character() -> BattleCharacter:
		return selectable_characters[selected_index]
	
	func increment_selected_index(index_increment: int):
		set_selected_index(selected_index + index_increment)
	
	func set_selected_index(index: int):
		selected_index = index
		
		var max_index = selectable_characters.size() - 1
		if selected_index < 0: selected_index = max_index
		elif selected_index > max_index: selected_index = 0
	
	func reset():
		for selectable_character in selectable_characters:
			selectable_character.set_as_selected(false)
		selected_index = 0

var current_party_selection: PartySelection
var player_party_selection: PartySelection
var enemy_party_selection: PartySelection

const BATTLE_CHARACTER = preload("res://battle/battle_character/battle_character.tscn")


func _ready():
	_init_character_roots()
	
	_init_player_party()
	_init_enemy_party()
	_init_party_selections()
	
	set_state(State.PLAYER_SELECTING)
	_update_selectable_characters(true)
	print(player_party_selection.get_selected_character())
	_update_selected_character_ui(player_party_selection)
	
	camera.reset_smoothing()


func _process(delta):
	_handle_controls_and_state_routing()


func _handle_controls_and_state_routing():
	match state:
		State.PLAYER_SELECTING:
			if Input.is_action_just_pressed("target_left"):
				player_party_selection.increment_selected_index(-1)
				_update_selected_character_ui(player_party_selection)
			if Input.is_action_just_pressed("target_right"):
				player_party_selection.increment_selected_index(1)
				_update_selected_character_ui(player_party_selection)
			if Input.is_action_just_pressed("confirm"):
				set_state(State.PLAYER_IDLE)
				_update_selected_character_ui(enemy_party_selection)
		State.PLAYER_IDLE:
			if Input.is_action_just_pressed("target_left"):
				enemy_party_selection.increment_selected_index(-1)
				_update_selected_character_ui(enemy_party_selection)
			if Input.is_action_just_pressed("target_right"):
				enemy_party_selection.increment_selected_index(1)
				_update_selected_character_ui(enemy_party_selection)
			if Input.is_action_just_pressed("back"):
				set_state(State.PLAYER_SELECTING)
				_update_selected_character_ui(player_party_selection)
			if Input.is_action_just_pressed("choose_ability"):
				set_state(State.PLAYER_MENU)
				battle_interface.set_choose_ability_ui_visibility(true, player_party_selection.get_selected_character().character_info)
		State.PLAYER_MENU:
			if Input.is_action_just_pressed("scroll_up"):
				battle_interface.increase_chosen_ability_index(-1, player_party_selection.get_selected_character().character_info)
			if Input.is_action_just_pressed("scroll_down"):
				battle_interface.increase_chosen_ability_index(1, player_party_selection.get_selected_character().character_info)
			if Input.is_action_just_pressed("back"):
				set_state(State.PLAYER_IDLE)
				_update_selected_character_ui(enemy_party_selection)
				battle_interface.set_choose_ability_ui_visibility(false)
			if Input.is_action_just_pressed("confirm"):
				set_state(State.PLAYER_ATTACKING)
				battle_interface.set_choose_ability_ui_visibility(false)
				_handle_player_attack()


func _init_character_roots():
	for root in player_roots.get_children():
		player_party_character_roots.append(root)
	for root in enemy_roots.get_children():
		enemy_party_character_roots.append(root)


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


func _init_party_selections():
	player_party_selection = PartySelection.new()
	enemy_party_selection = PartySelection.new()


func _get_root_index(number_on_team: int, team_size: int):
	return ((PartyInfo.MAX_SIZE - 1) - (team_size - 1)) + ((number_on_team * 2) - 2)


func _update_selectable_characters(reset: bool):
	if reset:
		player_party_selection.reset()
		enemy_party_selection.reset()
	
	# TODO Add logic for unselectable party members.
	player_party_selection.selectable_characters = player_characters
	enemy_party_selection.selectable_characters = enemy_characters
	print(player_party_selection.selectable_characters)


func _update_selected_character_ui(party_selection: PartySelection):
	camera.update_position(party_selection.get_selected_character())
	battle_interface.update_selected_character_info(party_selection.get_selected_character())
	
	# TODO Find a better way to do this.
	var all_characters: Array[BattleCharacter]
	all_characters.append_array(player_characters)
	all_characters.append_array(enemy_characters)
	for selectable_character in all_characters:
		selectable_character.set_as_selected(selectable_character == party_selection.get_selected_character(), state != State.PLAYER_SELECTING)


func set_state(new_state: State):
	self.state = new_state
	battle_interface.update_controls_ui(new_state)


func _handle_player_attack():
	await get_tree().create_timer(1.0).timeout
	var selected_ability = battle_interface.get_selected_ability(player_party_selection.get_selected_character().character_info)
	var attacker_character = player_party_selection.get_selected_character()
	var defender_character = enemy_party_selection.get_selected_character()
	BattleExecution.try_to_execute(selected_ability, attacker_character, defender_character, self)
	
	await get_tree().create_timer(1.0).timeout
	set_state(State.PLAYER_SELECTING)
	_update_selected_character_ui(player_party_selection)
