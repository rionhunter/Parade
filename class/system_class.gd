extends Node
class_name System

var core

var access = {} # the loaded subsystems

func _ready():
	core = get_tree().get_nodes_in_group('core')[0]
	print('mounted %s' % name)
	_prelaunch()
	launch_sequence()

func launch_sequence():
	pass
	
func _prelaunch():
	pass

# default initiation function for nodes using this class
func _launched():
	pass


func document(incoming_var, from = self.name):
	pass
	
func report():
	pass

func quit():
	core.auto_quit(self.name)

