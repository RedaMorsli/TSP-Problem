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

func tsp(start):
	var tab = []
	for p in points.get_children():
		if(p.label != str(start)):
			tab.append(p.label)
	
	var permuts = permut(tab)
	var result = permuts[0]
	result.append(start)
	result.push_front(start)
	var mini = d(result)
	#print(result)
	permuts.remove(0)
	for t in permuts:
		var temp_tab = t.duplicate()
		temp_tab.append(start)
		temp_tab.push_front(start)
		#print(temp_tab)
		var temp = d(temp_tab)
		if(temp < mini):
			mini = temp
			result = temp_tab
	return result

func d(tab : Array):
	if(tab.empty() or tab.size() == 1):
		return 0
	var result = between(tab[0], tab[1])
	if(tab.size() > 2): 
		for i in range(2, tab.size()):
			result += between(tab[i-1], tab[i])
	
	return result

func between(p1, p2):
	var a = str(p1)
	var b = str(p2)
	for l in links.get_children():
		if((a == l.start.label and b == l.end.label) or (a == l.end.label and b == l.start.label)):
			return l.d

func get_link(p1, p2):
	var a = str(p1)
	var b = str(p2)
	for l in links.get_children():
		if((a == l.start.label and b == l.end.label) or (a == l.end.label and b == l.start.label)):
			return l

func get_point(label):
	for p in points.get_children():
		if(p.label == str(label)):
			return p

func _add_point():
	#_reset_highlights()
	var point = Point.instance()
	point.label = Globals.id_count
	point.index = Globals.nb_points
	point.connect("point_clicked", self, "_on_point_clicked")
#	point.connect("start_link", self, "_on_start_link")
#	point.connect("apply_link", self, "_on_apply_link")
#	point.connect("mouse_entred_point", self, "_on_mouse_entred_point")
#	point.connect("mouse_exited_point", self, "_on_mouse_exited_point")
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


func _update_globals():
	Globals.center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	Globals.radius = Vector2(get_viewport_rect().size.y / 2 - 48, 0)

func _on_Button_pressed():
	_add_point()

func _on_point_clicked(point):
	highlight(tsp(point.label))

func highlight(tab : Array):
	reset_highlight()
	for i in range(tab.size() - 1):
		get_link(tab[i], tab[i+1]).set_highlight(true)
		get_point(i + 1).set_highlight(true)

func reset_highlight():
	for l in links.get_children():
		l.set_highlight(false)
	for p in points.get_children():
		p.set_highlight(false)

func permut(lst : Array):
	if(lst.empty()):
		return []
	
	if(lst.size() == 1):
		return [lst]
	
	var l = []
	
	for i in range(lst.size()):
		var m = lst[i]
		var remLst = lst.duplicate()
		remLst.remove(i)
		for p in permut(remLst):
			l.append([m] + p)
	return l 
