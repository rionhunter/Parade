extends Node

export (float, 0.0, 10.0, 1) var report_verbosity = 5

var system = {}
var process = {}


func _ready():
	establish_core()
	Mount.folder_to_values('res://', self)
	for thing in ['system', 'process']:
		print('%s : %s' % [thing.to_upper(), Convert.string(get(thing), true, false, true)])
	print(Convert.string(get_meta('program'), true, true, true))


func establish_core():
	add_to_group('core')



