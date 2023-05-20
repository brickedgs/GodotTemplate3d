extends Camera3D

var sprint_mode_toggle_in_progress = false
var sprint_mode_toggle_last_value = false

func toggle_sprint_mode(sprint):
	if sprint_mode_toggle_in_progress or sprint_mode_toggle_last_value == sprint:
		return

	var tween = create_tween()

	if sprint:
		tween.tween_property(self, 'fov', 90, 0.5)
	else:
		tween.tween_property(self, 'fov', 75, 0.5)

	sprint_mode_toggle_in_progress = true
	sprint_mode_toggle_last_value = sprint
	tween.tween_callback(sprint_mode_toggle_finished)

func sprint_mode_toggle_finished():
	sprint_mode_toggle_in_progress = false
