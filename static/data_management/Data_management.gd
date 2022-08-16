class_name files

enum {FOLDER, FILE, FILETYPE}
enum {NONE, RESOURCE, USER, ROOT}
enum {EXTENSION, EXTENSIONLESS}


const user = 'user://'
const resource = 'res://'
const user_preference_path = "user://data/"
const preference_filetype = '.parade'

# PATH

static func path(incoming_var, type = NONE):
	var output = ''
	match typeof(incoming_var):
		TYPE_STRING:
			if file_name(incoming_var).begins_with('.'):
				return false
			output =  _path_from_string(incoming_var, type)
		TYPE_ARRAY:
			if str(incoming_var[-1]).begins_with('.'):
				return false
			output =  _path_from_array(incoming_var, type)
		TYPE_DICTIONARY:
			if file_name(incoming_var['path']).begins_with('.'):
				return false
			output = incoming_var['path']
		_:
			print(typeof(incoming_var))
	match typeof(output):
		TYPE_STRING:
			if output.is_abs_path():
				return output
			else:
				if output == 'user:' or output == 'res:':
					return output + '//'
				print('Path concoction may have failed with %s' % output)
				return output
		TYPE_BOOL:
			return incoming_var

static func _path_from_string(incoming, type = NONE):
	match type:
		NONE:
			return incoming
		RESOURCE:
			return str('res://', incoming)
		USER:
			return str('user://', incoming)
		ROOT:
			return str(OS.get_root(), incoming)

static func _path_from_array(incoming_array, type = NONE):
	var output = ''
	match incoming_array[0]:
		'user:/', 'res:/':
			incoming_array[0] += '/'
		'user:', 'res:':
			incoming_array[0] += '//'
	match type:
		NONE:
			pass
		RESOURCE:
			output = 'res://'
		USER:
			output = 'user://'
		ROOT:
			output = OS.get_root()
	var size = incoming_array.size()
	for i in range(0, size):
		if not incoming_array[i]:
			continue
		var incoming = str(incoming_array[i])
		if incoming[0] == '.' and output[-1] == "/":
			output.rstrip("/")
		output += str(incoming_array[i])
		if i < size - 1 and not output.ends_with('/'):
			output += '/'
	return output


# get program's root folder in operating system
static func get_root_folder():
	return parent_folder_of_path(OS.get_executable_path())

# SCANNING

static func scan(address, type = with.FILE, file_type = ['tscn', '.gd']):
	match type:
		with.FILE:
			return scan_for_files(address)
		with.FILETYPE:
			return scan_folder_for_file_types(address, file_type)
		with.FOLDER:
			return scan_folders_for_folders(address)

static func scan_folders_for_folders(address):
	var d = Directory.new()
	d.open(address)
	var output = []
	var current = d.list_dir_begin(true, true)
	current = d.get_next()
	while current != '':
		if current.begins_with('.'):
			current = d.get_next()
			continue
		if d.dir_exists(current):
			output.append(current)
		current = d.get_next()
	return output

static func scan_folder_for_file_types(address, filetypes):
	if typeof(filetypes) == TYPE_STRING:
		filetypes = [filetypes]
	var files = scan_for_files(address)
	var output = []
	for i in files:
		if not i: continue
		for x in filetypes:
			if i.ends_with(x):
				output.append(i)
	return output

static func list_folders(address):
	return scan(address, with.FOLDER)

static func scan_for_files(address):
	var d = Directory.new()
	d.open(address)
	var output = []
	var current = d.list_dir_begin(true)
	current = d.get_next()
	while current != '':
		output.append(path([address, current]))
		current = d.get_next()
	d.list_dir_end()
	return output
	
static func scan_for_file_name(file_name, folder):
	var output_array : Array = scan_for_files(folder)
	for current_file in output_array:
		if current_file.ends_with(file_name):
			return current_file
	return false

static func parent_folder_of_path(incoming_path):
	match incoming_path:
		user, resource:
			return incoming_path
	var output : Array = incoming_path.split('/')
	output.pop_back()
	var out = path(output)
	return out

static func file_name(incoming_file_name, type = EXTENSION):
	if not incoming_file_name:
		print('ERROR: architecture.file_name has no incoming file name to convert')
		return
	elif 'workflow' in incoming_file_name:
		pass
	var output_array = incoming_file_name.split('/')
	var output = output_array[-1]
	match type:
		EXTENSION:
			return output
		EXTENSIONLESS:
			return output.split('.')[0]
	
static func bottom_folder(incoming_folder_path : String):
	var output : Array = incoming_folder_path.split('/')
	var current = output.pop_back()
	if '.' in current.right(current.length()-5):
		current = output.pop_back()
	return current

static func folder_exists(location):
	var d = Directory.new()
	if d.dir_exists(location):
		return true
	else:
		return false

#  recursively duplicate a folder and all its contents
static func duplicate_folder(folder_to_duplicate : String, location):
	var output_report = []
	var d = Directory.new()
	ensure_path(location)
	d.open(folder_to_duplicate)
	var current = d.list_dir_begin(true)
	current = d.get_next()
	print('opened %s and found %s' % [current, folder_to_duplicate])
	while current != '':
		var current_path = path([folder_to_duplicate, current])
		var current_location = path([location, current])
		print('assessing the item %s in the folder %s, moving it to %s' % [current, current_path, current_location])
		if typeof(current_path) == TYPE_BOOL:
			if not current_path:
				current = d.get_next()
				continue
		else:
			print('assessed succesffully - copying  %s to %s' % [current_path, current_location])
		if d.current_is_dir():
			duplicate_folder(current_path, current_location)
			output_report.append(current_location)
		else:
			copy_file(current_path, current_location)
			output_report.append(current_location)
		current = d.get_next()
	d.list_dir_end()
	return output_report

static func duplicate_file(file_to_duplicate, location):
	copy_file(file_to_duplicate, location)

static func copy_file(from, to):
	var f = File.new()
	if not file_exists(from):
		return 'Original file %s does not exist' % from
	f.open(from, File.READ)
	var file_as_string = f.get_as_text()
	f.close()
	var n = File.new()
	n.open(to, File.WRITE)
	n.store_string(file_as_string)
	n.close()
	return 'Copied %s to %s' % [from, to]


static func delete(incoming_path):
	var found_folders = scan(incoming_path, with.FOLDER)
	var found_files = scan_for_files(incoming_path)
	for i in found_folders:
		print('deleting folders %s' % Convert.string(i, true, false, true))
		delete_folder(path([incoming_path, i]))
	for i in found_files:
		delete_file(i)
		print('deleting files %s' % Convert.string(i, true, false, true))
		

static func delete_file(file_to_delete):
	var d = Directory.new()
	d.remove(file_to_delete)
	if file_exists(file_to_delete):
		return 'Failed to delete file %s' % file_to_delete
	else:
		return 'Deleted file %s' % file_to_delete


static func delete_folder(folder_to_delete):
	var d = Directory.new()
	d.open(folder_to_delete)
	var current = d.list_dir_begin(true)
	current = d.get_next()
	while current != '':
		if d.dir_exists(current):
			delete_folder(path([folder_to_delete, current]))
			print('deleting folders %s' % Convert.string(current, true, false, true))
		else:
			delete_file(path([folder_to_delete, current]))
			print('deleting files %s' % Convert.string(current, true, false, true))
		current = d.get_next()
	d.list_dir_end()
	d.remove(folder_to_delete)
	if folder_exists(folder_to_delete):
		print('failed to delete folder %s' % Convert.string(folder_to_delete, true, false, true))

static func delete_folder_and_contents(folder_to_delete):
	delete_folder(folder_to_delete)

static func move_file(from, to):
	var f = File.new()
	f.open(from)
	f.move(to)

static func move_folder(from, to):
	var d = Directory.new
	d.open(from)
	var current = d.list_dir_begin(true)
	current = d.get_next()
	while current != '':
		if d.dir_exists(current):
			move_folder(path([from, current]), path([to, current]))
		else:
			move_file(path([from, current]), path([to, current]))
		current = d.get_next()
	d.list_dir_end()
	d.move(to)

# use OS's default file browser to open folder
static func open_folder(location):
	var temp = OS.shell_open(location)
	return temp
	
	
# determine whether an array has the index length to be searched beyond that index
static func array_search_check(incoming_array, place):
	if place + 1 >= incoming_array.size():
		return false
	return true

static func make_dir(incoming_path):
	var d = Directory.new()
	d.make_dir(incoming_path)

static func file_exists(incoming_file):
	#return true if file exists
	var d = Directory.new()
	d.open(incoming_file)
	return d.file_exists(incoming_file)

static func swap_file_extension(incoming_file, new_extension):
	var output = incoming_file.split('.')
	output[output.size()-1] = new_extension
	return output.join('.')

static func save_file(incoming_file, incoming_data):
	var d = Directory.new()
	d.open(incoming_file)
	return d.save_file(incoming_file, incoming_data)

static func create_folder(incoming_folder):
	var d = Directory.new()
	print('making directory: ', incoming_folder)
	d.make_dir(incoming_folder)

static func exists(incoming_folder):
	var d = Directory.new()
	var output = d.dir_exists(incoming_folder)
	return output

static func ensure_path(incoming_path, _type = NONE):
	var d = Directory.new()
	incoming_path = root_path_check(incoming_path)
	d.make_dir_recursive(incoming_path)

static func root_path_check(incoming_path : String):
	if incoming_path.count('/', 3, 6) < 2:
		if incoming_path.begins_with('user:/'):
			incoming_path = incoming_path.insert(6, '/')
		elif incoming_path.begins_with('res:/'):
			incoming_path = incoming_path.insert(5, '/')
	if folder_exists(incoming_path) and not incoming_path.ends_with('/'):
		incoming_path += '/'
	return incoming_path

# ~~~~~~~~~~~~~~~~~~~~~~ TXT AND FURTHER FILE MANAGEMENT ~~~~~~~~~~~~~~~~~~~~~~

static func txt_to_string(incoming_address):
	if not incoming_address:
		print('Error: failed to convert incoming txt to string')
	var f = File.new()
	f.open(incoming_address, File.READ)
	var output = f.get_as_text()
	f.close()
	return output

static func txt_to_array(incoming_address):
	var output = txt_to_string(incoming_address)
	var output_array = output.split('\n')
	return output_array

# _____________ SAVING TO JSON & TXT

static func load_from_json(incoming_file):
	var f = File.new()
	if not f.file_exists(incoming_file):
		return false
	var _temp = f.open(incoming_file, f.READ)
	var text = f.get_as_text()
	f.close()
	return parse_json(text)

static func save_to_json(location : String, incoming_text):
	ensure_path(parent_folder_of_path(location))
	if not location.is_abs_path():
		print('failed to save to json %s' % location)
		return
	var f = File.new()
	var _to_write = f.open(location,File.WRITE)
	f.store_line(to_json(incoming_text))
	f.close()
	if file_exists(location):
		return true
	else: return false

static func save_to_txt(location, incoming_text : String):
	ensure_path(parent_folder_of_path(location))
	var txt = incoming_text.replace('\n', '\n').rstrip('\n. ')
	if not location.ends_with('.txt'):
		location += '.txt'
	var f = File.new()
	var _to_write = f.open(location, File.WRITE)
	f.store_string(txt)
	f.close()
	if file_exists(location):
		return true
	else: return false

static func append_to_txt(location, incoming_text : String):
	var previous = txt_to_string(location)
	var output = previous + '\n' + incoming_text
	save_to_txt(location,output)

static func rename_file(old_path, new_path):
	var f = File.new()
	f.open(old_path)
	f.move(new_path)

# _____________ SAVINGTO CUSTOM FILETYPES

static func save_to_custom_filetype(location, name, incoming_text, filetype):
	var f = File.new()
	var output = path([location, name + filetype])
	# combine location, name and filetype
	var _to_write = f.open(output, File.WRITE)
	f.store_string(Convert.string(incoming_text, false))
	f.close()
	return output

static func open(path, output_as_array = false):
	if file_name(path).begins_with('.'): return
	var f = File.new()
	f.open(path, File.READ)
	var output = f.get_as_text()
	f.close()
	if output_as_array:
		output = output.split('\n')
	return output

static func save_preferences(name, incoming_dictionary):
	return save_to_json(path([user_preference_path, name + preference_filetype]), incoming_dictionary)

static func load_preference(name):
	var file_path = path([user_preference_path, name + preference_filetype])
	if file_exists(file_path):
		var output = load_from_json(file_path)
		if output:   
			return output
	return false
