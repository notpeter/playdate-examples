
title = { updateScalar = 4, visible = true, phase = 1 }
titleImage = LCD:new('Title/Title', 132, 26)

function title:setVisible(flag)
	self.visible = flag
	titleImage:setOn(flag)

	if not flag then
		lines:select(0)
	end
end

function title:showAll(flag)
	titleImage:setOn(flag)
	lines:showAll(flag)
end

function title:update()
	if self.visible
	then
		self.phase = (self.phase % #lines.list) + 1

		list = { 1, 2, 3, 4 }
		table.remove(list, self.phase)

		lines:selectList(list)
	end
end

lines = LCDGroup:new({
	LCD:new('Title/TitleLines1', 127, 26),
	LCD:new('Title/TitleLines2', 123, 26),
	LCD:new('Title/TitleLines3', 119, 26),
	LCD:new('Title/TitleLines4', 115, 26)
})
