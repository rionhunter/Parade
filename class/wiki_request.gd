extends Node
class_name wiki


var request_string = 'https://data.rion.dev/api.php?action=query&format=json&export=1&titles=Escapade'

var output

func free():
	return make_request(output)

func make_request(path = request_string):
	var web = HTTPRequest.new()
	add_child(web)
	var _connect = web.connect('request_completed', self, 'parse_value')
	web.request(path)
	for _i in 2:
		yield(web, "request_completed")
	return output[3].get_string_from_utf8
	
	

func parse_value(v1, v2, v3, v4 : PoolByteArray):
	output = v4.get_string_from_utf8()
	var outgoing = parse_json(output)
	print(outgoing)
	emit_signal('request_completed')
