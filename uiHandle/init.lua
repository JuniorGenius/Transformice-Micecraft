setElement = function(type, identifier, height, width, yoff, xoff, ex)
	local obj = {}
	
	obj.type = type
	obj.identifier = identifier
	
	obj.height = height
	obj.width = width
	
	obj.xcent = 400 - (width / 2) + (xoff or 0)
	obj.ycent = 205 - (height / 2) + (yoff or 0)
	
	if type == "image" then
		obj.remove = tfm.exec.removeImage
		obj.update = dummyFunc
	elseif type == "textArea" then
		obj.remove = ui.removeTextArea
		obj.update = ui.updateTextArea
	else
		obj.remove = dummyFunc
		obj.update = dummyFunc
	end
	
	ex = ex or {}
	 
	for k, v in next, ex do
		if not obj[k] then
			obj[k] = v
		end
	end
	
	return obj
end

uiResources[0] = {
	[1] = setElement(
		"image", "baseWin", 335, 501, 0, 0,
		{image = "1804def6229.png"}
	),
	[2] = setElement(
		"textArea", "default", 305, 469, 0, 0,
		{container = true,
		format = {
			start = "<font face='Consolas' color='#ffffff'>",
			enclose = "</font>"
		}}
	),
	[10] = setElement(
		"textArea", "close", 25, 25, -148, 225,
		{text = "<font size='24' face='Consolas' color='#FFFFFF'><a href='event:%s'>X</font>", event="close"}
	)
}

uiResources[0.5] = {
	[1] = setElement(
		"image", "baseWin", 335, 501, 22, 0,
		{image = "1804def6229.png"}
	),
	[2] = setElement(
		"textArea", "default", 305, 469, 22, 0,
		{container = true,
		format = {
			start = "<font face='Consolas' color='#ffffff'>",
			enclose = "</font>"
		}}
	),
	[4] = setElement(
        "image", "titleWin", 32, 501, -150, 0,
        {image = "1804df01146.png"}
    ),
    [5] = setElement(
        "textArea", "title", 22, 455, -152, -10,
        {container = true,
		format = {
			start = "<font face='Consolas' color='#000000' size='18'><p align='center'>",
			enclose = "</p></font>"
		}}
    ),
	[10] = setElement(
		"textArea", "close", 25, 25, -150, 235,
		{text = "<font size='24' face='Consolas' color='#000000'><a href='event:%s'>X</font>", event="close"}
	)
}

--[[
uiResources[1] = inherit(uiResources[0], {
	[4] = setElement(
		"image", "pageWin", -, -, -, -,
		{image = ""}
	),
	[5] = setElement(
		"textArea", "leftswitch", -, -, -, -,
		{text = "<font size='n' color='#FFFFFF'><a href='event:%s'> CHARACTER", event="leftswitch"}
	)
	[6] = ^copy^
})]]