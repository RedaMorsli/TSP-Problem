extends Node2D

const FONT = preload("res://assets/fonts/normal.tres")

var start
var end
var d := 0
var hidden
var hover = false

onready var dNode = $Area2D
onready var dLabel = $Area2D/Sprite/Label

func _ready():
	dLabel.text = str(d)

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
	if hover:
		color = Color.red
	else:
		color = Color.black
	draw_line(start.position, end.position, color, 2.00, true)
	dNode.position = pos1 + (pos1.direction_to(pos2) * (pos1.distance_to(pos2) * Globals.d_pos) )

func _process(delta):
	update()
