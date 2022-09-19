extends Node
class_name wiki_old


var request_string = 'https://data.rion.dev/api.php?action=query&format=json&prop=pageprops&export=1&generator=prefixsearch&gpssearch=Escapade%2Fupdates%2F'

signal results
signal complete

var output
var x : XMLParser
var web : HTTPRequest

func _ready():
	x = XMLParser.new()
	web = HTTPRequest.new()
	add_child(web)
	var _connect = web.connect('request_completed', self, 'parse_value')
	_connect = connect("complete",self,'set_value')
	
	
func set_value(incoming_value):
	output = incoming_value


func free():
	return make_request(output)

func make_request(path = request_string):
	web.request(path)
	yield(self, "complete")
	if not output:
		yield(get_tree(), 'idle_frame')
	print(output)
	return output
	
	

func parse_value(v1, v2, v3, v4 : PoolByteArray):
	var outgoing = v4.get_string_from_utf8()
	outgoing = parse_json(outgoing)
	var _temp = x.open(outgoing)
	outgoing = x.get_node_data()
	output = outgoing
	yield(get_tree(), 'idle_frame')
	emit_signal('complete')
	emit_signal('results', outgoing)
