function init_image( element, ordinary_image, enter_image, is_existed_handler )
	element:setData( "ordinary_image", ordinary_image, false )
	element:setData( "enter_image", enter_image, false )

	dgs:dgsImageSetImage( element, ordinary_image )

	if is_existed_handler then return end

	addEventHandler( "onDgsMouseEnter", element, function()
		dgs:dgsImageSetImage( source, source:getData( "enter_image" ) )
	end, false )

	addEventHandler( "onDgsMouseLeave", element, function()
		dgs:dgsImageSetImage( source, source:getData( "ordinary_image" ) )
	end, false )
end