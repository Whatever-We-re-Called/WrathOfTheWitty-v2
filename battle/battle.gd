class_name Battle extends Node2D


@export_group("Parties")
@export var player_party: PartyInfo
@export var enemy_party: PartyInfo

@onready var camera = $Camera2D
@onready var battle_interface = $CanvasLayer/BattleInterface
@onready var enemy_roots = $EnemyRoots
@onready var player_roots = $PlayerRoots
@onready var state_machine = $StateMachine

var current_state: BattleState
var states: Dictionary = {}

var player_party_character_roots: Array[Node2D]
var enemy_party_character_roots: Array[Node2D]
var player_characters: Array[BattleCharacter]
var enemy_characters: Array[BattleCharacter]
var battle_selections: BattleSelections
var current_player_mana: int
var current_selected_abilities: Array[Ability]

const BATTLE_CHARACTER = preload("res://battle/battle_character/battle_character.tscn")


func _ready():
	_init_states()
	_init_character_roots()
	
	_init_player_party()
	_init_enemy_party()
	_init_party_selections()
	
	change_to_state("PlayerStart")
	
	camera.reset_smoothing()


func _process(delta):
	if current_state != null:
		current_state._update()


func _init_states():
	for child in state_machine.get_children():
		if child is BattleState:
			states[child.name.to_lower()] = child
			child.init(self)


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
		battle_character.updated_player_stats.connect(_on_updated_player_stats)
		
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


func _init_party_selections():
	battle_selections = BattleSelections.new()
	battle_selections.updated_selected_character.connect(update_selected_character)
	battle_selections.init(self)


func change_to_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	if new_state == null: return
	if current_state == new_state: return
	
	if current_state != null:
		current_state._exit()
	
	new_state._enter()
	
	battle_interface.reset_controls_ui()
	new_state._update_controls_ui()
	
	current_state = new_state


func update_selected_character(selected_character: BattleCharacter):
	camera.update_position(selected_character)
	battle_interface.update_selected_character_info(selected_character)


func reset_for_player_turn():
	current_player_mana = player_party.max_mana
	battle_interface.update_mana_ui(current_player_mana)
	
	#for i in range(player_characters.size()):
		#if player_characters[i].health >= 0:
			#party_selections.set_selected_character_index(Constants.CharacterSelectState.PLAYER_SELECT, i, true)
			#break
	
	current_selected_abilities.clear()


func update_current_player_mana(mana_change: int):
	current_player_mana += mana_change
	battle_interface.update_mana_ui(current_player_mana)


func can_current_mana_afford_ability(ability: Ability) -> bool:
	return current_player_mana <= ability.mana_cost


# TODO Probably updated current_selected_ability to properly
# seperate single vs array (multiple) data handling?
func update_current_selected_ability(selected_ability: Ability):
	current_selected_abilities.clear()
	current_selected_abilities.append(selected_ability)


func update_current_selected_abilities(selected_abilities: Array[Ability]):
	current_selected_abilities.clear()
	current_selected_abilities.append_array(selected_abilities)


func get_current_selected_ability() -> Ability:
	return current_selected_abilities[0]


func get_current_selected_abilities() -> Array[Ability]:
	return current_selected_abilities


func reset_current_selected_abilities():
	current_selected_abilities.clear()


func lock_camera_on_party(characters: Array[BattleCharacter]):
	var middle_index = characters.size() / 2
	camera.lock_at_position(characters[middle_index])


func _on_updated_player_stats():
	battle_interface.update_player_character_info(player_characters)


#func try_to_execute_selected_ability():
	#var selected_ability = battle_interface.get_selected_ability(party_selections.get_selected_player_character().character_info)
	#var ability_mana_cost = selected_ability.mana_cost
	#if current_player_mana < ability_mana_cost:
		#return
	#else:
		#change_to_state("PlayerTarget")
		#battle_interface.set_choose_ability_ui_visibility(false)
