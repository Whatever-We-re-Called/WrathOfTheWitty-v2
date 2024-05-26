@tool
extends Node

@export var elements: UIElementResource
@export var presets: UIElementResource
	
var is_self_being_hovered_over = false
var waiting_on_double_click = false


func _ready():
	for child in get_children():
		remove_child(child)
		child.free()
		
	var elements_tree = Tree.new()
	elements_tree.name = "Elements"
	add_child(elements_tree)
	load_items(elements, elements_tree, null)
	
	var presets_tree = Tree.new()
	presets_tree.name = "Presets"
	add_child(presets_tree)
	load_items(presets, presets_tree, null)
	
	handle_self_connected_signals(self)
	
	
func load_items(resource, tree, parent):
	var node = new_item(resource, tree, parent)
	for child in resource.children:
		load_items(child, tree, node)
	
	
func new_item(resource, tree, parent):
	var node = tree.create_item(parent)
	node.set_text(0, resource.name)
	node.set_icon(0, resource.icon)
	node.set_icon_max_width(0, 15)
	node.set_metadata(0, resource)
	return node


func handle_self_connected_signals(parent):
	if parent.get_children().size() == 0: return
	
	for child in parent.get_children():
		child.mouse_entered.connect(_on_mouse_entered)
		child.mouse_exited.connect(_on_mouse_exited)
		handle_self_connected_signals(child)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if is_self_being_hovered_over:
					if _get_active_tree().get_selected():
						if _get_active_tree().get_selected().get_metadata(0) != null:
							if waiting_on_double_click:
								add_item_to_scene(_get_active_tree().get_selected().get_metadata(0))
							else:
								wait_on_double_click()
								
					
func wait_on_double_click():
	waiting_on_double_click = true
	await get_tree().create_timer(.5).timeout
	waiting_on_double_click = false


func add_item_to_scene(resource):
	for node in EditorInterface.get_selection().get_selected_nodes():
		var element
		
		if resource.script_file.resource_path.ends_with(".gd"):
			element = resource.script_file.new()
		elif resource.script_file.resource_path.ends_with(".tscn"):
			element = resource.script_file.instantiate()
			
		node.add_child(element)
		element.owner = get_tree().edited_scene_root
		element.name = resource.name
		await get_tree().process_frame
		EditorInterface.edit_node(element)


func _get_active_tree() -> Tree:
	for container in get_children():
		if container.visible:
			return container
	return null


func _on_mouse_entered():
	is_self_being_hovered_over = true


func _on_mouse_exited():
	is_self_being_hovered_over = false
