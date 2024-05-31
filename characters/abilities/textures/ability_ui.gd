extends ColorRect

@onready var ability_icon = %AbilityIcon
@onready var ability_insult_label = %AbilityInsultLabel
@onready var mana_value_label = %ManaValueLabel


func init(ability: Ability, is_selected: bool, is_selectable: bool):
	ability_icon.texture = Constants.get_ability_type_icon(ability.type)
	ability_insult_label.text = ability.insult
	mana_value_label.text = str(ability.mana_cost)
	
	if is_selected:
		color = Color("#646464")
	elif not is_selectable:
		color = Color("#191919")
	else:
		color = Color("#4b4b4b")
