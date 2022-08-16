extends Core
class_name System

var access = {} # the loaded subsystems

func initialise():
	_prelaunch()
	launch_sequence()

func launch_sequence():
	if not core.launched:
		yield(core, 'completed_loading')
	_launched()

func _prelaunch():
	pass

# default initiation function for nodes using this class
func _launched():
	pass


func document(incoming_var, from = self.name):
	pass
	
func report():
	pass

func quit():
	core.auto_quit(self.name)

