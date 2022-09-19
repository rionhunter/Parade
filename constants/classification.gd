class_name classification

enum {default, category, system}

static func folder_category(incoming_path):
	var folder_name : String = files.file_name(incoming_path)
	if folder_name.begins_with('_'):
		if folder_name.ends_with('_'):
			return category
		else:
			return system
	else:
		return default

static func strip(incoming : String):
	return incoming.lstrip('_').rstrip('_')
