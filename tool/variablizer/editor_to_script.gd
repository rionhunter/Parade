extends Node

var core

func _ready():
	if not OS.is_debug_build():
		return
	yield(get_tree(), 'idle_frame')
	core = fetch.core(get_tree())
	
	var web_stuff = wiki.new()
