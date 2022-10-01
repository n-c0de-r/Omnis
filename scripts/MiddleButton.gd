extends TextureButton

func updateMiddle(flag: bool):
	self.pressed = flag
	if flag:
		$Text.text = "Your\nTurn"
	else:
		$Text.text = "Com\nTurn"
