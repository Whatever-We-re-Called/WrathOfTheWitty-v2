extends ColorRect

@onready var ability_icon = %AbilityIcon
@onready var ability_insult_label = %AbilityInsultLabel
@onready var mana_value_label = %ManaValueLabel
@onready var weak_tag = %WeakTag

var enemy_character_info: CharacterInfo
var ability: Ability


func init(enemy_character_info: CharacterInfo, ability: Ability, index: int, selected_index: int, current_mana: int):
	self.enemy_character_info = enemy_character_info
	self.ability = ability
	
	ability_icon.texture = Constants.get_ability_type_icon(ability.type)
	ability_insult_label.text = ability.insult
	mana_value_label.text = str(ability.mana_cost)
	z_index = 100 + -index
	
	var is_selectable = current_mana >= ability.mana_cost
	var is_selected = index == selected_index
	if not is_selectable:
		color = Color("#191919")
	elif is_selected:
		color = Color("#646464")
	else:
		color = Color("#4b4b4b")
	
	update_tag()


func update_tag():
	var ability_insecurity = Constants.get_matching_insecurity_for_ability_type(ability.type)
	var is_weak_to_ability = enemy_character_info.insecurity_weaknesses.has(ability_insecurity)
	weak_tag.visible = is_weak_to_ability
