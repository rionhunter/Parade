extends Node
class_name Core

var core
var system
var process
var exchange

func _init(scene_tree):
	core = fetch.core(scene_tree)
	system = core.system
	process = core.process
	exchange = system.exchange
