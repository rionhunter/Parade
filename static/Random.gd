class_name Random

static func coin():
	randomize()
	var output = randf()
	if output > 0.5:
		return true
	else: return false
	
