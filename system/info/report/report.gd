extends System

func _launched():
	pass

# categories, tags, urgency levels, 

func update(source, message):
	print(" %s | %s" % [source, Convert.string(message)])
	
