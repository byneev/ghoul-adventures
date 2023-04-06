extends Control

var actions
var current_level
var level_ref

func _ready():
	actions = get_node('Actions')
	current_level = get_node('Level')
	level_ref = get_parent()

func _process(delta):
	actions.text = 'actions: %d' % level_ref.actions_count
	current_level.text = 'level %d' % level_ref.current_level
	




func _on_Up_button_down():
	var ev = InputEventAction.new()
	ev.action = 'up'
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_Left_button_down():
	var ev = InputEventAction.new()
	ev.action = 'left'
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_Right_button_down():
	var ev = InputEventAction.new()
	ev.action = 'right'
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_Down_button_down():
	var ev = InputEventAction.new()
	ev.action = 'down'
	ev.pressed = true
	Input.parse_input_event(ev)
