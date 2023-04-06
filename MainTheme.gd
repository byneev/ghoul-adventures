extends AudioStreamPlayer


func _ready():
	get_tree().root.get_child(get_tree().root.get_child_count() - 1).free()
	var level = ResourceLoader.load('res://scenes/levels/Level1.tscn')
	var level_instance = level.instantiate()
	get_tree().root.add_child(level_instance)
	get_tree().current_scene = level_instance
