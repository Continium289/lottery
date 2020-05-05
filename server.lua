local tParticipation = {}
local tTimers        = {}
local tPickupsBusy   = {}

local function set_pickup_unbusy( thePlayer )
    for pickup, player in pairs( tPickupsBusy ) do
        if player == thePlayer then
            tPickupsBusy[ pickup ] = false
            break
        end
    end
end

addEventHandler( "onPickupHit", resourceRoot, function( player )
    local player_login = player:getAccount():getName()
    if player:getType() ~= "player" or tParticipation[ player_login ] or tPickupsBusy[ source ] then return end

    triggerClientEvent( player, "DB_base_open_window", resourceRoot )
    tPickupsBusy[ source ] = player
end )

addCommandHandler( "create_marker", function( thePlayer, _ )
    if thePlayer:getInterior() ~= 0 or thePlayer:getDimension() ~= 0 or not hasObjectPermissionTo( thePlayer, "function.kickPlayer", false ) then return end

    local vector_coordinates = thePlayer:getPosition()

    createPickup( vector_coordinates.x + 5, vector_coordinates.y, vector_coordinates.z, 3, 1272, 1000 )
    outputChatBox( "Пикап успешно создан!", thePlayer )
end )

addEvent( "DB_base_on_press_button_to_begin", true )
addEventHandler( "DB_base_on_press_button_to_begin", resourceRoot, function( progress )
    local player_login = client:getAccount():getName()
    if client:getMoney() < 50000 or tParticipation[ player_login ] or progress ~= 0  then 
        set_pickup_unbusy( client )
        return 
    end

    client:giveMoney( -50000 )
    tParticipation[ player_login ] = true

    local progress = 0
    local player = client
    local timer = setTimer( function()
        progress = progress + 1
        triggerClientEvent( player, "DB_base_set_timer_value", resourceRoot, progress )

        if progress == 100 then
            local tSequence = {}
            for i = 1, 10 do
                tSequence[ i ] = i
            end
            local offset = math.random( 1, 9 )
            table.sort( tSequence, function( first, second )
                return ( first + offset ) % 10 > ( second + offset ) % 10
            end )
            triggerClientEvent( player, "DB_base_on_change_picture_fone", resourceRoot, tSequence )
            iprint(tSequence)
            tTimers[ player ] = nil
        end

    end, 10, 100 )
    tTimers[ client ] = timer
end )

local function onExit_handler( _, _, boolean_quit )
    if tTimers[ source ] then
        killTimer( tTimers[ source ] )
        tTimers[ source ] = nil
    end

    set_pickup_unbusy( source )

    if boolean_quit then return end

    triggerClientEvent( source, "DB_base_destroy_UI", resourceRoot )
end

addEventHandler( "onPlayerLogout", root, onExit_handler )
addEventHandler( "onPlayerQuit", root, onExit_handler )

addEventHandler( "onResourceStart", resourceRoot, function()

    setTimer( function()
        tParticipation = {}
    end, 1000 * 60 * 60 * 24, 0 )

end )

addEvent( "DB_base_set_pickup_free", true )
addEventHandler( "DB_base_set_pickup_free", resourceRoot, function()
    set_pickup_unbusy( client )
end )