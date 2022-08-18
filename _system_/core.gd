extends Node

export (float, 0.0, 10.0, 1) var report_verbosity = 5

var system = {}
var process = {}
var program = {}

func _ready():
	establish_core()
	auto_load_folder()
	for thing in ['system', 'process', 'program']:
		print('%s : %s' % [thing.to_upper(), Convert.string(get(thing), true, false, true)])


func establish_core():
	add_to_group('core')


func auto_load_folder(folder_path = 'res://'):
	var folders = files.scan_for_folders(folder_path)
	for folder in folders:
		if folder.begins_with('_'):
			var title = folder.lstrip('_').rstrip('_')
			if get(title) != null:
				var mounting_path = files.path(['res://', folder], with.FOLDER) + '/'
				var new_node = Mount.node(self)
				new_node.name = title
				set(title, Mount.systems(mounting_path, new_node))
			else:
				print('could not find value for %s' % title)
		
