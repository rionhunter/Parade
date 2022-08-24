extends Node

export var launch_program = 'wync'
export (float, 0.0, 10.0, 1) var report_verbosity = 5
export var filter = ''
export var scene_override = ''
export var simulate_first_launch = false
export var open_log = false
export var open_files = false



var system = {}
var process = {}
var program = {}


func _ready():
	establish_core()
	Mount.folder_to_values('res://', self)
	var w = Mount.this(wiki.new(), self, 'wiki')
	print(w.make_request())

func establish_core():
	add_to_group('core')


