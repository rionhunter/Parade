extends Node

var core

export (float, 0.0, 10.0, 1.0) var report_verbosity = 5.0
export var open_logs = false
export var simulate_first_launch = false


func _ready():
	if not OS.is_debug_build():
		return
	yield(get_tree(), 'idle_frame')
	core = fetch.core(get_tree())
	
	var web_stuff = wiki_old.new()
