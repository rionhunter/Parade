extends Node
class_name System

var core

var access = {} # the loaded subsystems

var location = ''

func _init(incoming_location = 'res://'):
	location = incoming_location

func _ready():
	core = fetch.core(get_tree())
	establish_subsystems()
	_prelaunch()
	_launch_sequence()
	_launched()



func save_files():
	var list = get_method_list()


func establish_identity():
	var outgoing_title = get_script().get_path().right(6).replace('/','_')
	print(location)

func establish_subsystems():
	var path = self.get_script().get_path()
	print(location)
	print('%s parent is %s' % [self.name, get_parent().name])

func _launch_sequence():
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

