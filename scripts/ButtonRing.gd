extends Control

signal animation_done

var buttons: Array = []
var ring: Array = [] # only ring of colors

var idx: int

func _ready():
	ring = $Colors.get_children()
	$Timer.start(1 * Utils.timerFactor)

# Checks if all buttons are unpressed
func areAllReleased():
	var result: bool = true
	for btn in ring:
		result = result and !btn.pressed
	return result

# Plays the animation for given button list 
func playList(list: Array):
	# Disable all buttons
	toggleButtonsClickable(false)
	idx = 0
	buttons = list
	$Timer.start(1 * Utils.timerFactor)

# Simulates a button press
func press(name: String):
	$Colors.get_node("%s" % name.to_upper()).simulatePress()
	return name

# Simulates a button release
func release(name: String):
	$Colors.get_node("%s" % name.to_upper()).simulateRelease()
	return name

# Rotates buttons 90 degrees in a random direction
func rotateButtons(direction: int):
	for btn in ring:
		btn.rotateButton(90*direction, 1.0 * Utils.timerFactor)

# Sets chosen theme of symbols
func setSymbols(name: String, set: Array):
	for i in set.size():
		var s: TextureRect = ring[i].get_node("Symbol")
		s.texture = load("res://assets/gfx/symbols/%s%s.png" % [name, set[i]])
	pass

# Sets description texts for buttons
func setTexts(name:String, set: Array):
	for i in set.size():
		var t: Label = ring[i].get_node("Text")
		t.text = set[i]
	pass

# Plays a single button animation with delay
func _playButton(name: String):
	$Timer.start(2 * Utils.timerFactor)
	$Colors.get_node("%s" % name.to_upper()).animate(1 * Utils.timerFactor)

# Makes buttons clickable or unclickable
func toggleButtonsClickable(flag: bool):
	$CENTER.updateMiddle(flag)
	for btn in ring:
		btn.button_mask = int(flag)

func _on_Timer_timeout():
	# Play each button with delay
	if idx < buttons.size():
		_playButton(buttons[idx])
		idx += 1
	else:
		# After animation, enable all buttons
		emit_signal("animation_done")
