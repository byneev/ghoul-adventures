extends Area2D

var level
var first_field
var last_field
var rise
var rate
var counter = 0
var anim_count = 8
export var sprite_size = 32
var is_brain_eaten = false
var has_ladder = false
var has_leaf = false
var has_key = false
var is_frozen = false
var level_done = false
var items = []
var items_map = {'leaf':null, 'ladder':null}
var is_dead = false
var water_steps_count = 0
var snow_steps_count = 0

signal level_done
signal action_done

func _ready():
	level = get_parent()
	rise = level.get_node('Rise')
	rate = float(anim_count) / level.actions_count
	first_field = level.get_node('Start')
	last_field = level.get_node('End')

func _input(event):
	emit_signal("input_event")
	if is_dead:
		return
	var new_position = position
	if event.is_action_pressed("Quit"):
		get_tree().change_scene("res://scenes/Menu.tscn")
	elif event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("up"):
		new_position.y -= sprite_size
		if check_movement(new_position):
			position.y -= sprite_size
	elif event.is_action_pressed("down"):
		new_position.y += sprite_size
		if check_movement(new_position):
			position.y += sprite_size
	elif event.is_action_pressed("left"):
		new_position.x -= sprite_size
		if check_movement(new_position):
			position.x -= sprite_size
	elif event.is_action_pressed("right"):
		new_position.x += sprite_size
		if check_movement(new_position):
			position.x += sprite_size

func check_movement(position):
	if position.x > last_field.position.x + sprite_size or position.x < first_field.position.x or position.y > last_field.position.y + sprite_size or position.y < first_field.position.y:
		return false
	var gates = level.get_node('Gates')
	if gates:
		if gates.position.y <= position.y and position.y < gates.position.y + sprite_size and gates.position.x <= position.x and position.x < gates.position.x + sprite_size:
			if has_key:
				gates.queue_free()
				level.get_node('Key_item').visible = false
				get_node("Open_Gates").play()
				return true
			else:
				get_node("Cant_step").play()
				return false
	emit_signal("action_done")
	counter += rate
	rise.frame = floor(counter)
	get_node("Step").play()
	return true


# warning-ignore:unused_argument
func _on_Brain_area_entered(area):
	is_brain_eaten = true
	level.get_node('Brain_item').visible = true
	get_node("Get_brain").play()


# warning-ignore:unused_argument
func _on_Grave_area_entered(area):
	if is_brain_eaten:
		emit_signal('level_done')
		get_node("Win").play()
		get_node("AnimatedSprite").frame = 0
		level_done = true


func _on_Player_area_entered(area):
	var name = area.get_name().rstrip('0123456789')
	if name != 'Water':
		water_steps_count = 0
	match(name):
		'Water':
			if has_leaf and water_steps_count == 0:
				level.get_node('Leaf_item').visible = false
				water_steps_count += 1
				items_map.leaf.position.x = area.position.x
				items_map.leaf.position.y = area.position.y
				items_map.leaf.visible = true
			else:
				is_dead = true
				get_node("AnimatedSprite").visible = false
				area.get_node('AnimatedSprite').frame = 1
				level.get_node('AfterDead').start()
				get_node("Underwater").play()
		'Leaf':
			if not has_leaf:
				has_leaf = true
				level.get_node('Leaf_item').visible = true
				get_node("Get_item").play()
				items_map.leaf = area
				items_map.leaf.set_collision_mask(0)
				items_map.leaf.set_collision_layer(0)
				items_map.leaf.visible = false
		'Trap':
			pass
		'Trap_open':
			level.get_node('AfterDead').start()
			get_node("AnimatedSprite").frame = 5
			get_node("Lava_dead").play()
			is_dead = true
		'Lava':
			if is_frozen:
				is_frozen = false
				snow_steps_count = 0
				get_node("AnimatedSprite").frame = 0
				get_node("Lava_snow").play()
			else:
				level.get_node('AfterDead').start()
				get_node("AnimatedSprite").frame = 2
				get_node("Lava_dead").play()
				is_dead = true
		'Snow':
			if not is_frozen:
				is_frozen = true
				get_node("AnimatedSprite").frame = 3
				get_node("Frozen").play()
			snow_steps_count += 1
			if snow_steps_count >= 2:
				level.get_node('AfterDead').start()
				get_node("AnimatedSprite").frame = 4
				get_node("Frozen_full").play()
				is_dead = true
		'Key':
			if not has_key:
				has_key = true
				level.get_node('Key_item').visible = true
				get_node("Get_item").play()
				area.queue_free()
			


func _on_Player_area_exited(area):
	var name = area.get_name().rstrip('0123456789')
	match(name):
		'Water':
			if has_leaf:
				items_map.leaf.visible = false
				if not is_dead:
					level.get_node('Leaf_item').visible = true
		'Ladder':
			pass
		'Trap':
			var trap_open_name = 'Trap_open'
			if area.get_name() != name:
				trap_open_name += area.get_name().rstrip('a-zA-Z')
			area.queue_free()
			level.get_node(trap_open_name).collision_layer = 2
			level.get_node(trap_open_name).collision_mask = 1
			get_node("Trap_activate").play()
