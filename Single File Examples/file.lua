
-- writes to a test data file, then reads it back line by line, adding the first two numbers on a line just for fun


file = playdate.file.open("test.txt", playdate.file.kFileWrite)
file:write("1 2\r3 4\n5 6\r\n7 8")
file:close()


file = playdate.file.open("test.txt", playdate.file.kFileRead)

repeat

	l = file:readline()
	print(l)

	if l then
		print(l:match("(%d+)", 1) + l:match("(%d+)", 2))
	end
	print()

until l == nil

playdate.stop()

function playdate.update()
end
