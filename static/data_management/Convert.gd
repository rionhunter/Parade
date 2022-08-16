class_name Convert

const divider_1 = ' | '
const divider_2 = ' ~~~~ '
const space = ' '
const sentence_markers = ['.', '!', '?']





static func array_to_string(incoming_array, with_spaces = false, with_new_lines = false, divider = false, strip_extension = false):
	var output = ''
	for value in incoming_array:
		if strip_extension:
			value = value.split('/')[-1].split('.')[0]
		output += str(value)
		if with_spaces:
			output += ' '
		if divider:
			output += divider_1
		if with_new_lines:
			output += '\n'
	return output

static func paragraphs_to_string(incoming_array):
	var output = ''
	for paragraph in incoming_array:
		for sentence in paragraph:
			for word in sentence:
				match typeof(word):
					TYPE_STRING:
						output += word
					TYPE_ARRAY:
						output += array_to_string(word)
		output += '\n'
	return output

# convert dict to string
static func dictionary_to_string(incoming_dict, with_spaces = true, with_new_lines = true, divider = false):
	var output = ''
	for key in incoming_dict.keys():
		var value = incoming_dict[key]
		# if value is array, convert it to string
		if typeof(value) == TYPE_ARRAY:
			value = array_to_string(value, with_spaces, with_new_lines)
		if with_spaces:
			output += str(key) + space + ':' + space + str(value)
		else:
			output += key + ':' + str(value)
		if divider:
			output += divider_1
	return output

#  convert dict values  to array
static func dictionary_to_array(incoming_dict, with_spaces = true, with_new_lines = false, with_keys = false):
	var output = []
	for key in incoming_dict.keys():
		var value = incoming_dict[key]
		# if value is array, convert it to string
		if typeof(value) == TYPE_ARRAY:
			value = array_to_string(value, with_spaces)
		if with_keys:
			output.append(key)
		if with_new_lines:
			output.append('\n')
		output.append(value)
		if with_spaces:
			output.append(' ')
	return output

static func string(incoming_value, with_spaces = true, with_new_lines = true, divider = false, strip_extension = false):
	if typeof(incoming_value) == TYPE_ARRAY:
		return array_to_string(incoming_value, with_spaces, with_new_lines, divider, strip_extension)
	if typeof(incoming_value) == TYPE_DICTIONARY:
		return dictionary_to_string(incoming_value, with_spaces, with_new_lines, divider)
	if typeof(incoming_value) == TYPE_STRING:
		return incoming_value
	return str(incoming_value)

const sentence_marker = ['.', '?', '!', '"']

static func string_to_paragraphs(incoming_string):
	var queue : Array = incoming_string.split('\n')
	var paragraphs = []
	var sentences = []
	while queue:
		var current = queue.pop_front()
		var current_sentence = []
		for word in current.split(' '):
			for sm in sentence_marker:
				if word.ends_with(sm):
					sentences.append(current_sentence)
					current_sentence.clear()
				else:
					current_sentence.append(word)
		paragraphs.append(sentences)
		sentences.clear()
	return paragraphs

static func to_stamp(incoming_array):
	var divider = '_'
	var output = ''
	for entry in incoming_array:
		output += entry + divider
	return output

