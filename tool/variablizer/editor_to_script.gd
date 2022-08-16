extends Node

var core

func _ready():
	if not OS.is_debug_build():
		return
		
	core = get_parent()
	if not core.system.empty():
		parse_value(core, core.system)
	pass
	

func parse_value(script : Node, value):
	var script_path = script.get_path()
	print(script_path)
