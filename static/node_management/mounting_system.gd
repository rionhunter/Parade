class_name Mount

# Systems are effectively just folders with scripts in them that are of the same name as the folder
static func systems(incoming_folder_of_systems, node_to_parent):
	var incoming_array = Data.scan_folders_for_folders(incoming_folder_of_systems)
	var output = {}
	for sub_system in incoming_array:
		output[sub_system] = system(Data.path([incoming_folder_of_systems, sub_system]), node_to_parent)
	return output

static func system(incoming_system_file_path, incoming_parent):
	var script_to_load = Data.scan(incoming_system_file_path, Data.FILETYPE, ['.gd'])
	if not script_to_load:
		print('failed to load ', incoming_system_file_path)
		return null
#	print('Mounted ', Data.file_name(incoming_system_file_path))
	return script_to_node(node(incoming_parent), script_to_load[0])

static func subsystems(node, folder_name = 'subsystem'):
	var to_path : String = Data.parent_folder_of_path(node.get_script().get_path()) + '/'
	to_path = to_path.insert(4, '/')
	var results = Data.scan_folders_for_folders(to_path)
	if folder_name in results:
		to_path = Data.path([to_path, 'subsystem'])
		return systems(to_path, node)

static func node(incoming_parent):
	var output = Node.new()
	incoming_parent.add_child(output)
	return output

static func script_to_node(incoming_node, incoming_script):
	var a = load(incoming_script)
	incoming_node.set_script(a)
	incoming_node.name = Data.file_name(incoming_script, Data.EXTENSIONLESS)
	return incoming_node

static func auto_node(incoming_script_address, parent) -> Node:
	var output_node = node(parent)
	var pending_name = Data.file_name(incoming_script_address, Data.EXTENSIONLESS)
	var output = script_to_node(output_node, incoming_script_address)
	output.name = pending_name.lstrip('_')
	return output

static func signals(incoming_array : Array, parent : Node):
	for i in incoming_array:
		parent.add_user_signal(i)
