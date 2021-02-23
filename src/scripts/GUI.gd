extends Control

onready var cycleLabel = $Control/MarginContainer/VBoxContainer/Cycle
onready var totalLabel = $Control/MarginContainer/VBoxContainer/Total

func _ready():
	$Graph.connect("update", self, "update_ui")
	$Graph.connect("reset", self, "reset")


func update_ui(tab, total):
	var s = "Cycle : "
	for i in tab:
		s += str(i) + " -> "
	s.erase(s.find_last(" -> "), 4)
	cycleLabel.text = s
	totalLabel.text = "Distance Total : " + str(total)


func reset():
	cycleLabel.text = ""
	totalLabel.text = ""

