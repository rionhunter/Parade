extends Node
class_name Field_Report

var source = ''
var body = []
var urgency = 5
var tags = []
var categories = []

var report_master : Node

func _init(from, message):
	source = from
	add(message)
	yield(self, "tree_entered")
	report_master = fetch.the('Report', get_tree())
	

func add_tag(tag):
	match typeof(tag):
		TYPE_STRING:
			tags.append(tag)
		TYPE_ARRAY:
			tags = tags + tag
	update_tags()
	return tags

func add_to_category(category_title):
	categories.append(category_title)
	return categories

func update_tags():
	for entry in tags:
		if not is_in_group(report_tag(entry)):
			add_to_group(report_tag(entry))

func report_tag(title):
	return 'report_%s' % title

func add(message):
	body.append(message)


