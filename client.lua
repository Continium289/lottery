dgs = exports.dgs
local tUI_elements 		= {}
local tUI_pictures_data = {}

local function init_ui_elements()
	tUI_elements.window = dgs:dgsCreateWindow( 200, 0, 900, 800, "Лотерея", false )
	tUI_elements.images = {}
	local px_common, py_image, py_text
	for i = 1, 10 do
		if i < 6 then
			px_common = 150 * i - 100
			py_image = 50
			py_text = 150
		else
			px_common = 150 * ( i - 5 ) - 100
			py_image = 250
			py_text = 350
		end
		tUI_elements.images[ i ] = dgs:dgsCreateImage( px_common, py_image, 100, 100, nil, false, tUI_elements.window )
		init_image( tUI_elements.images[ i ], nil, "images/zamok.png", false )
		dgs:dgsCreateLabel( px_common + 50, py_text, 10, 10, i, false, tUI_elements.window, tocolor( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ), 255 ) )
	end

	tUI_elements.button = dgs:dgsCreateImage( 600, 400, 200, 150, nil, false, tUI_elements.window )
	init_image( tUI_elements.button, "images/button.png", "images/go.png", false )

	dgs:dgsCreateImage( 50, 400, 500, 200, "images/rules.png", false, tUI_elements.window )


	-- dgs:dgsRemoveEasingFunction("testing5590")
	-- dgs:dgsAddEasingFunction("testing5590",[[
	-- 	local tmp_1 = setting[3][1] + progress * ( setting[2][1] - setting[3][1])
	-- 	local tmp_2 = setting[3][2] + progress * ( setting[2][2] - setting[3][2])
	-- 	return { tmp_1, tmp_2 }
	-- ]])

	tUI_elements.progress_bar = dgs:dgsCreateProgressBar( 100, 700, 600 ,10, false, tUI_elements.window )

	addEventHandler( "onDgsMouseClickDown", tUI_elements.button, function()
		triggerServerEvent( "lottery_on_press_button_to_begin", resourceRoot, dgs:dgsGetProperty( tUI_elements.progress_bar, "progress" ) )
	end, false )

	addEventHandler( "onDgsDestroy", tUI_elements.window, function()
		showCursor( false )
		tUI_elements = {}
		triggerServerEvent( "lottery_set_pickup_free", resourceRoot )
	end, false )
	
end

addEvent( "lottery_open_window", true )
addEventHandler( "lottery_open_window", resourceRoot, function()
	if tUI_elements.window then return end

	init_ui_elements()
	showCursor( true )
end )

addEvent( "lottery_set_timer_value", true )
addEventHandler( "lottery_set_timer_value", resourceRoot, function( progress )
	dgs:dgsProgressBarSetProgress( tUI_elements.progress_bar, progress )
end )

addEvent( "lottery_destroy_UI", true )
addEventHandler( "lottery_destroy_UI", resourceRoot, function()
	destroyElement( tUI_elements.window )
	tUI_elements = {}
end )

addEvent( "lottery_on_change_picture_fone", true )
addEventHandler( "lottery_on_change_picture_fone", resourceRoot, function( tSequence )
	tUI_pictures_data = tSequence

	for i = 1, 10 do
		init_image( tUI_elements.images[ i ], "images/open.png", "images/zamok.png", false )
		addEventHandler( "onDgsMouseClickDown", tUI_elements.images[ i ], function()
			local number_picture = tUI_pictures_data[ i ]
			if not number_picture then return end

			if number_picture then
				local ordinary_image

				if number_picture ~= 5 and number_picture ~= 7 then
					ordinary_image = "images/min_win.png"
				else
					ordinary_image = "images/" .. tostring( number_picture ) .. ".png"
				end

				init_image( source, ordinary_image, "images/opened.png", false )
				triggerServerEvent( "lottery_on_correcting_attempts", resourceRoot, number_picture )
				tUI_pictures_data[ i ] = nil
			end
		end, false )
	end
end )