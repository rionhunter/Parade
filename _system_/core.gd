extends Node

export var launch_program = 'wync'

var system = {}
var process = {}
var program = {}


func _ready():
	establish_core()
	Mount.folder_to_values('res://', self)
	test()

func establish_core():
	add_to_group('core')

func test():
	var notes = Field_Report.new(launch_program, 'Establishing Field report')
	add_child(notes)
	notes.add_tag('test')
	var test = get_tree().get_nodes_in_group('report_test')[0]
	print(test.body)
