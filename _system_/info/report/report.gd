extends System

func _prelaunch():
	breakpoint
	pass

# categories, tags, urgency levels, 

func update(source, message):
	print(" %s | %s" % [source, Convert.string(message)])
	
