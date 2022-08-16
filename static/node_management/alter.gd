class_name alter

static func set_name_to_script_name(incoming_node : Node, lower = true) -> String:
	var output : String = Data.bottom_folder(incoming_node.get_script().get_path())
	var _o
	if lower:
		_o = output.to_lower()
		incoming_node.name = _o
	else:
		incoming_node.name = output
	return output
