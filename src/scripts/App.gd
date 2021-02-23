extends Node2D

const Point = preload("res://src/scenes/Point.tscn")
const Link = preload("res://src/scenes/Link.tscn")

onready var points = $Points
onready var links = $Links


func _draw():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	_update_globals()

func _add_point():
	#_reset_highlights()
	var point = Point.instance()
	point.label = Globals.id_count
	point.index = Globals.nb_points
	point.connect("start_link", self, "_on_start_link")
	point.connect("apply_link", self, "_on_apply_link")
	point.connect("mouse_entred_point", self, "_on_mouse_entred_point")
	point.connect("mouse_exited_point", self, "_on_mouse_exited_point")
	points.add_child(point)
	
#	var item = PointItem.instance()
#	item.label = Globals.id_count
#	item.connect("delete_point", self, "_remove_point")
#	item.connect("hide_point", self, "_hide_point")
#	poointList.add_child(item)
	
	Globals.nb_points += 1
	Globals.id_count += 1
	
	for p in points.get_children():
		_add_link(point, p)


func _add_link(start, end):
	#_reset_highlights()
	for l in links.get_children():
		if (l.start == start and l.end == end) or (l.start == end and l.end == start):
			return
	if start == end:
		return
	var link = Link.instance()
	link.start = start
	link.end = end
	links.add_child(link)
	
#	var item = LinkItem.instance()
#	item.start = start
#	item.end = end
#	item.connect("delete_link", self, "_remove_link")
#	item.connect("hover_link_item", self, "_hover_link_item")
#	item.connect("exit_link_item", self, "_exit_link_item")
#	linkList.add_child(item)


func _on_add_point_pressed():
	_add_point()

func _update_globals():
	Globals.center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	Globals.radius = Vector2(get_viewport_rect().size.y / 2 - 48, 0)



func _on_Button_pressed():
	_add_point()
