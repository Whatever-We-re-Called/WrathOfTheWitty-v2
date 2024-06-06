class_name BattleCamera extends Camera2D

@export var max_x_pivot: int
@export var max_y_pivot: int

@onready var max_x = float(get_viewport_rect().size.x / 2)
@onready var max_y = float(get_viewport_rect().size.y / 2)

var is_locked = false


func update_position(target_node: Node2D):
	if not is_locked:
		var x_i = float(target_node.global_position.x) / max_x
		position.x = EasingFunctions.ease_out_sine(0, max_x_pivot, x_i)
		var y_i = float(target_node.global_position.y) / max_y
		position.y = EasingFunctions.ease_out_sine(0, max_y_pivot, y_i)


func lock_at_position(target_node: Node2D):
	update_position(target_node)
	is_locked = true


func unlock():
	is_locked = false
