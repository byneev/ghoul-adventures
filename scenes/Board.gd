extends Node2D

export var current_level = 0
export var actions_count = 0
export var grid_size = 0

func _on_Player_level_done():
	get_node("AfterWin").start()


func _on_Player_action_done():
	actions_count -= 1
	if actions_count <= 0:
		get_node("Player").is_dead = true
		get_node("CheckActions").start()


func _on_AfterDead_timeout():
	get_tree().reload_current_scene()


func _on_AfterWin_timeout():
	if current_level == 10:
		get_tree().change_scene("res://scenes/Menu.tscn")
		self.queue_free()
	else:
		get_tree().change_scene('res://scenes/levels/Level%d.tscn' % (self.current_level + 1))
		self.queue_free()


func _on_CheckActions_timeout():
	if not get_node("Player").level_done:
		get_node("Player").get_node("AnimatedSprite").frame = 1
		get_node("Player").get_node("Lava_dead").play()
		actions_count = 0
		get_node("AfterDead").start()
