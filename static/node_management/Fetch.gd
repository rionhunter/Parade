class_name fetch

static func core(node_tree):
	return node_tree.get_nodes_in_group('core')[0]

static func get_parent_by_editor_description(incoming_node : Node, description):
	match incoming_node.editor_description:
		description:
			return incoming_node
		_:
			return get_parent_by_editor_description(incoming_node.get_parent(), description)
	
static func first_parent_with_script(incoming_node : Node):
	if not incoming_node.get_script():
		first_parent_with_script(incoming_node.get_parent())
	elif incoming_node.name == 'root':
		return false
	else:
		return incoming_node

static func first_parent_with_signal(incoming_signal : String, node : Node):
	if not node.has_signal(incoming_signal):
		first_parent_with_signal(incoming_signal, node.get_parent())
	elif node.name == 'root':
			return false
	else:
		return node

static func first_parent_with_method(method : String, node : Node):
	if not node.has_method(method):
		return first_parent_with_method(method, node.get_parent())
	elif node.name == 'root':
		return false
	else:		
		return node
