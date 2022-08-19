class_name Mount


static func folder(incoming_path, node_to_parent):
	var found = files.scan_for_folders(incoming_path)
	var output = {}
	for f in found:
		var output_path = files.path([incoming_path, f]) + '/'
		match classification.folder_category(f):
			classification.category:
				output[f] = systems(output_path, node_to_parent)
				continue
			classification.system:
				output[f] = system(output_path, node_to_parent)
				continue
	return output

static func category(incoming_path, node_to_parent):
	var found = files.scan_for_folders(incoming_path)
	var output = {}
	for x in found:
		output[x] = system(files.path([incoming_path, x]), node_to_parent)
	return output

	
# Systems are effectively just folders with scripts in them that are of the same name as the folder
static func systems(incoming_folder_of_systems, node_to_parent):
	print('Mounting systems for %s' % incoming_folder_of_systems)
	var incoming_array = files.scan_for_folders(incoming_folder_of_systems)
	var output = {}
	for sub_system in incoming_array:
		output[sub_system] = system(files.path([incoming_folder_of_systems, sub_system]), node_to_parent)
	return output

static func system(incoming_system_file_path, incoming_parent):
	var script_to_load = files.scan(incoming_system_file_path, files.FILETYPE, ['.gd'])
	if not script_to_load:
		var output = System.new()
		incoming_parent.add_child(output)
		output.name = files.file_name(incoming_system_file_path)
		
		return output
	folder(incoming_system_file_path, incoming_parent)
#	print('Mounted ', files.file_name(incoming_system_file_path))
	return script_to_node(node(incoming_parent), script_to_load[0])

static func scan_script_path(incoming_node):
	return files.scan_for_folders(script_path(incoming_node))

static func script_path(incoming_node):
	var to_path : String = files.parent_folder_of_path(incoming_node.get_script().get_path()) + '/'
	return to_path.insert(4, '/')


static func subsystems(incoming_node, folder_name = 'subsystem'):
	var to_path : String = files.parent_folder_of_path(incoming_node.get_script().get_path()) + '/'
	to_path = to_path.insert(4, '/')
	var results = scan_script_path(incoming_node)
	if folder_name in results:
		to_path = files.path([to_path, 'subsystem'])
		return systems(to_path, incoming_node)

static func node(incoming_parent, incoming_name = ''):
	var output = Node.new()
	incoming_parent.add_child(output)
	if incoming_name:
		output.name = incoming_name
	return output

static func this(node, parent, incoming_name = ''):
	parent.add_child(node)
	if incoming_name:
		node.name = incoming_name
	return node

static func script_to_node(incoming_node, incoming_script):
	var a = load(incoming_script)
	incoming_node.set_script(a)
	incoming_node.name = files.file_name(incoming_script, files.EXTENSIONLESS)
	return incoming_node

static func auto_node(incoming_script_address, parent) -> Node:
	var output_node = node(parent)
	var pending_name = files.file_name(incoming_script_address, files.EXTENSIONLESS)
	var output = script_to_node(output_node, incoming_script_address)
	output.name = pending_name.lstrip('_')
	return output

static func signals(incoming_array : Array, parent : Node):
	for i in incoming_array:
		parent.add_user_signal(i)

static func values(incoming_node : Node, variable, value):
	print(incoming_node.name)
	if incoming_node.get(variable) != null:
		incoming_node.set(variable, value)
		print('set %s to %s for %s' % [variable, value, incoming_node.name])
	else:
		print('failed to set %s on %s' % [variable, incoming_node.name])
		incoming_node.set_meta(variable, value)

static func folder_to_values(incoming_folder : String, incoming_node : Node):
	var folders = files.scan_for_folders(incoming_folder)
	for f in folders:
		match classification.folder_category(f):
			classification.category:
				var variable_name = classification.strip(f)
				var variable_path = files.path([incoming_folder, f]) + '/'
				var variable_value = category(variable_path, incoming_node)
				values(incoming_node, variable_name, variable_value)
			classification.system:
				values(incoming_node, classification.strip(f), system(files.path([incoming_folder, f]), incoming_node))
