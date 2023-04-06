extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Play").grab_focus()

func _input(event):
	if event.is_action_pressed("ui_down"):
		get_node("Quit").grab_focus()
		get_node("Quit").add_color_override("font_color", Color8(59, 47, 91, 255))
		get_node("Play").add_color_override("font_color", Color8(36, 29, 56, 255))
	if event.is_action_pressed("ui_up"):
		get_node("Play").grab_focus()
		get_node("Play").add_color_override("font_color", Color8(59, 47, 91, 255))
		get_node("Quit").add_color_override("font_color", Color8(36, 29, 56, 255))

func _on_Play_button_down():
	get_tree().change_scene("res://scenes/levels/Level1.tscn")
	queue_free()


func _on_Quit_button_down():
	get_tree().quit()

