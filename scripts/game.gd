extends Node
# new test
# new test 2
onready var main_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
onready var world = main_scene.get_node("world")

func _ready():
	pass
