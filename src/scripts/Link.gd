extends Node2D

const FONT = preload("res://assets/fonts/normal.tres")
const blue_circle = preload("res://assets/circle_outline_blue.png")
const black_circle = preload("res://assets/circle_outline.png")
const BLUE = Color8(61, 174, 233)

var start
var end
var d := 0
var hidden
var hover = false
var highlight = false

onready var dNode = $Area2D
onready var dLabel = $Area2D/Sprite/Label
onready var dSprite = $Area2D/Sprite

func set_highlight(h):
	if(h):
		dSprite.texture = blue_circle
		highlight = true
		dLabel.set("custom_colors/font_color", BLUE)
	else:
		highlight = false
		dSprite.texture = black_circle
		dLabel.set("custom_colors/font_color", Color.black)

func set_focus(is_focused):
	var current_alpha = modulate.a
	if is_focused:
		$OpacityTween.interpolate_property(self, "modulate", Color(1, 1, 1, current_alpha), Color(1, 1, 1, 1), 0.7, Tween.TRANS_EXPO)
		$OpacityTween.start()
	else:
		$OpacityTween.interpolate_property(self, "modulate", Color(1, 1, 1, current_alpha), Color(1, 1, 1, 0.1), 0.7, Tween.TRANS_EXPO)
		$OpacityTween.start()

func set_visible(visible):
	var current_alpha = modulate.a
	if visible:
		hidden = false
		$OpacityTween.interpolate_property(self, "modulate", Color(1, 1, 1, current_alpha), Color(1, 1, 1, 1), 0.7, Tween.TRANS_EXPO)
		$OpacityTween.start()
	else:
		hidden = true
		$OpacityTween.interpolate_property(self, "modulate", Color(1, 1, 1, current_alpha), Color(1, 1, 1, 0.05), 0.7, Tween.TRANS_EXPO)
		$OpacityTween.start()

func _draw():
	var pos1 = start.position
	var pos2 = end.position
	var color
	if highlight:
		color = BLUE
	elif hover:
		color = Color.red
	else:
		color = Color.black
	draw_line(start.position, end.position, color, 4.00, true)
	dNode.position = pos1 + (pos1.direction_to(pos2) * (pos1.distance_to(pos2) * Globals.d_pos))
	dLabel.text = str(d)

func _process(delta):
	update()

func _on_Label_gui_input(event):
	if(Input.is_action_just_pressed("ui_increase")):
		d += 1
	if(Input.is_action_just_pressed("ui_decrease")):
		d -= 1
		if(d < 0):
			d = 0
