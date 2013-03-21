# +----------------------------------------------+
# | Jessassin's Plot Management System           |
# | Auto_Include.ms                              |
# +----------------------------------------------+

proc(_plotmanager_init,@player,
	#initializes player in persistance DB, if they do not have values there.
	include('/includes/options.ms')
	if(
		not(has_value(concat(@player,'_plotcount'))),
			store_value(concat(@player,'_plotcount'),0)
	)
	if(
		not(has_value(concat(@player,'_maxplotcount'))),
			store_value(concat(@player,'_maxplotcount'),@defaultplotcount)
	)
)

proc(_get_player_plotinfo,@player,
	#given player
	#	returns the plots that payer owns in an array
	#	returns number of plots they own
	#	returns number of plots they can still claim
	if(
		has_value(concat(@player,'_plotarray')),
			assign(@plotarray,get_value(concat(@player,'_plotarray')))
	)
	if(
		has_value(concat(@player,'_plotcount')),
			assign(@plotcount,get_value(concat(@player,'_plotcount')))
	)
	if(
		has_value(concat(@player,'_maxplotcount')),
			assign(@maxplotcount,get_value(concat(@player,'_maxplotcount')))
	)
	return(array(@plotarray,@plotcount,@maxplotcount))
)

proc(_get_plot_owner,@plotaddress,
	#given plot address, returns owner of plot
	if(
		has_value(concat(@plotaddress,'_owner')),
			assign(@plotowner,get_value(concat(@plotaddress,'_owner'))),
			assign(@plotowner,'No owner')
	)
	return(@plotowner)
)

proc(_get_plot_members,@plotaddress,
	#given plot address, returns 'members' of the plot
	if(
		has_value(concat(@plotaddress,'_memberarray')),
			assign(@plotmembers,get_value(concat(@plotaddress,'_memberarray')))
	)
	return(@plotmembers)
)

proc(_get_plot_guests,@plotaddress,
	#given plot address, returns 'guests' of the plot
	if(
		has_value(concat(@plotaddress,'_guestarray')),
			assign(@guestarray,get_value(concat(@plotaddress,'_guestarray')))
	)
	return(@guestarray)
)

proc(_plot_addmember,@plotaddress,@member,@player,
	assign(@plotowner,_get_plot_owner(@plotaddress))
	if(
		has_value(concat(@plotaddress,'_memberarray')),
			assign(@plotmemberarray,get_value(concat(@plotaddress,'_memberarray'))),
			assign(@plotmemberarray,array())
	)
	if(
		array_contains_ic(@plotmemberarray,@member),
			return(concat('Player: ',@member,' is already a member!'))
	)
	array_push(@plotmemberarray,@member)
	if(
		equals_ic(@player,_get_plot_owner(@plotaddress)),
		store_value(concat(@plotaddress,'_memberarray'),@plotmemberarray)
		return(concat('Player: ',@member,' added to members!')),
		return('You do not own this plot!')
	)
)

proc(_plot_addguest,@plotaddress,@guest,@player,
	assign(@plotowner,_get_plot_owner(@plotaddress))
	if(
		has_value(concat(@plotaddress,'_guestarray')),
			assign(@plotguestarray,get_value(concat(@plotaddress,'_guestarray'))),
			assign(@plotguestarray,array())
	)
	if(
		array_contains_ic(@plotguestarray,@guest),
			return(concat('Player: ',@guest,' is already a guest!'))
	)
	array_push(@plotguestarray,@guest)
	if(
		equals_ic(@player,_get_plot_owner(@plotaddress)),
		store_value(concat(@plotaddress,'_guestarray'),@plotguestarray)
		return(concat('Player: ',@guest,' added to guests!')),
		return('You do not own this plot!')
	)
)

#proc(_plot_removemember,
#
#)

#proc(_plot_removeguest,
#
#)

#proc(_set_plot_members,@plotaddress,@memberarray,
#	
#)

#proc(_set_plot_guests,@plotaddress,@guestarray,
#	
#)

proc(_claimplot,@coords,@player,
	#given plot coordinates and player, claims plot as player
	#	returns on error: 
	#		plot already owned
	#		player too many plots
	assign(@playerinfo,_get_player_plotinfo(@player))
	assign(@plotinfo,_plotinfo(@coords))
	#player vars
	assign(@ownedplotarray,@playerinfo[0])
	assign(@ownedplotcount,@playerinfo[1])
	assign(@maxplotcount,@playerinfo[2])
	#plot vars
	assign(@plotaddress,@plotinfo[3])
	assign(@plotowner,@plotinfo[4])
	assign(@plotmemberarray,@plotinfo[5])
	#check if plot is owned
	if(
		gt(length(@plotowner),1),
		return('Plot is already owned!')
	)
	#check if player has avaliable plots
	if(
		lte(@maxplotcount,0),
		return('You already own the max number of plots!')
	)
	#assign vars to be written
	assign(@newownedplotcount,add(@ownedplotcount,1))
	assign(@newmaxplotcount,subtract(@maxplotcount,1))
	if(
		gt(length(@ownedplotarray),0),
		assign(@newownedplotarray,@ownedplotarray)
		array_push(@newownedplotarray,@plotaddress),
		assign(@newownedplotarray,array(@plotaddress))
	)
	#write to persistance DB
	store_value(concat(@player,'_plotcount'),@newownedplotcount)
	store_value(concat(@player,'_maxplotcount'),@newmaxplotcount)
	store_value(concat(@player,'_plotarray'),@newownedplotarray)
	store_value(concat(@plotaddress,'_owner'),@player)
)

proc(_unclaimplot,@coords,@player,
	#given coordinates and player, unclaims plot as player
	#	returns on error:
	#		plot not owned by anyone
	#		plot not owned by player running command
	assign(@playerinfo,_get_player_plotinfo(@player))
	assign(@plotinfo,_plotinfo(@coords))
	#player vars
	assign(@ownedplotarray,@playerinfo[0])
	assign(@ownedplotcount,@playerinfo[1])
	assign(@maxplotcount,@playerinfo[2])
	#plot vars
	assign(@plotaddress,@plotinfo[3])
	assign(@plotowner,@plotinfo[4])
	assign(@plotmemberarray,@plotinfo[5])
	#check if plot is owned
	if(
		lt(length(@plotowner),1),
		return('Plot is not owned!')
	)
	#check if plot is owned by player
	if(
		not(equals_ic(@player,@plotowner)),
		return('You do not own this plot!')
	)
	#assign vars to be written
	assign(@newownedplotcount,subtract(@ownedplotcount,1))
	assign(@newmaxplotcount,add(@maxplotcount,1))
	assign(@newownedplotarray,@ownedplotarray)
	assign(@counter,0)
	foreach(@newownedplotarray,@plot,
		if(equals(@plot,@plotaddress),
			assign(@removeindex,@counter)
		)
		assign(@counter,add(@counter,1))
	)
	array_remove(@newownedplotarray,@removeindex)
	#write vars to persistance DB
	store_value(concat(@player,'_plotcount'),@newownedplotcount)
	store_value(concat(@player,'_maxplotcount'),@newmaxplotcount)
	store_value(concat(@player,'_plotarray'),@newownedplotarray)
	store_value(concat(@plotaddress,'_owner'),'')
	store_value(concat(@plotaddress,'_memberarray'),array())
)

proc(_plot_address_coordinates,@address,
	#given a plot address, returns coordinates that are inside that plot
	assign(@split,reg_split('',@address))
	array_remove(@split,0)
	assign(@quad,@split[0])
	assign(@x,concat(@split[1],@split[2]))
	assign(@z,concat(@split[3],@split[4]))
	return(array(@quad,@x,@z))
)

proc(_map_location,@address,
	#Given plot address, returns information relevant to the plot map
	include('/includes/options.ms')
	assign(@addresscoords,_plot_address_coordinates(@address))
	assign(@quadrant,@addresscoords[0])
	assign(@x,@addresscoords[1])
	assign(@z,@addresscoords[2])
	assign(@newx,multiply(@x,3))
	assign(@newz,multiply(@z,3))
	assign(@maplocation,@mapcenter)
	if(equals(@quadrant,1),
		assign(@newerx,add(@maplocation[0],@newx))
		assign(@newerz,add(@maplocation[2],@newz))
		assign(@point2,array(add(@newerx,1),@maplocation[1],add(@newerz,1)))
	)
	if(equals(@quadrant,2),
		assign(@newerx,add(@maplocation[0],@newx))
		assign(@newerz,subtract(@maplocation[2],@newz))
		assign(@point2,array(add(@newerx,1),@maplocation[1],subtract(@newerz,1)))
	)
	if(equals(@quadrant,3),
		assign(@newerx,subtract(@maplocation[0],@newx))
		assign(@newerz,subtract(@maplocation[2],@newz))
		assign(@point2,array(subtract(@newerx,1),@maplocation[1],subtract(@newerz,1)))
	)
	if(equals(@quadrant,4),
		assign(@newerx,subtract(@maplocation[0],@newx))
		assign(@newerz,add(@maplocation[2],@newz))
		assign(@point2,array(subtract(@newerx,1),@maplocation[1],add(@newerz,1)))
	)
	return(array(@quadrant,@newerx,@newerz,@point2))
)

proc(_plotcorners,@locationarray,
	#Given a coordinate set, returns coordinates that corrospond to the corners of the plot
	include('/includes/options.ms')
	assign(@plotsize,@plotsize)
	assign(@plotsize1,subtract(@plotsize,1))
	assign(@quadrant,_currentquadrant(@locationarray))
	assign(@x,round(@locationarray[0]))
	assign(@y,round(@locationarray[1]))
	assign(@z,round(@locationarray[2]))
	assign(@modx,mod(@x,@plotsize))
	assign(@modz,mod(@z,@plotsize))
	assign(@realx,subtract(@x,@modx))
	assign(@realz,subtract(@z,@modz))
	if(equals(@quadrant,1),
		assign(@oppositespawncorner[0],add(@realx,@plotsize1))
		assign(@oppositespawncorner[1],1)
		assign(@oppositespawncorner[2],add(@realz,@plotsize1))
		assign(@spawncorner,array(@realx,1,@realz))
		assign(@refcorner,@spawncorner)
		assign(@corner1,@refcorner)
		assign(@corner2,array(@refcorner[0],1,add(@refcorner[2],@plotsize1)))
		assign(@corner3,array(add(@refcorner[0],@plotsize1),1,add(@refcorner[2],@plotsize1)))
		assign(@corner4,array(add(@refcorner[0],@plotsize1),1,@refcorner[2]))
	)
	if(equals(@quadrant,2),
		assign(@realz,subtract(@realz,1))
		assign(@oppositespawncorner[0],add(@realx,@plotsize1))
		assign(@oppositespawncorner[1],1)
		assign(@oppositespawncorner[2],subtract(@realz,@plotsize1))
		assign(@spawncorner,array(@realx,1,@realz))
		assign(@refcorner,array(@spawncorner[0],1,subtract(@spawncorner[2],@plotsize1)))
		assign(@corner1,@refcorner)
		assign(@corner2,array(@refcorner[0],1,add(@refcorner[2],@plotsize1)))
		assign(@corner3,array(add(@refcorner[0],@plotsize1),1,add(@refcorner[2],@plotsize1)))
		assign(@corner4,array(add(@refcorner[0],@plotsize1),1,@refcorner[2]))
	)
	if(equals(@quadrant,3),
		assign(@realx,subtract(@realx,1))
		assign(@realz,subtract(@realz,1))
		assign(@oppositespawncorner[0],subtract(@realx,@plotsize1))
		assign(@oppositespawncorner[1],1)
		assign(@oppositespawncorner[2],subtract(@realz,@plotsize1))
		assign(@spawncorner,array(@realx,1,@realz))
		assign(@refcorner,array(subtract(@spawncorner[0],@plotsize1),1,subtract(@spawncorner[2],@plotsize1)))
		assign(@corner1,@refcorner)
		assign(@corner2,array(@refcorner[0],1,add(@refcorner[2],@plotsize1)))
		assign(@corner3,array(add(@refcorner[0],@plotsize1),1,add(@refcorner[2],@plotsize1)))
		assign(@corner4,array(add(@refcorner[0],@plotsize1),1,@refcorner[2]))
	)
	if(equals(@quadrant,4),
		assign(@realx,subtract(@realx,1))
		assign(@oppositespawncorner[0],subtract(@realx,@plotsize1))
		assign(@oppositespawncorner[1],1)
		assign(@oppositespawncorner[2],add(@realz,@plotsize1))
		assign(@spawncorner,array(@realx,1,@realz))
		assign(@refcorner,array(subtract(@spawncorner[0],@plotsize1),1,@spawncorner[2]))
		assign(@corner1,@refcorner)
		assign(@corner2,array(@refcorner[0],1,add(@refcorner[2],@plotsize1)))
		assign(@corner3,array(add(@refcorner[0],@plotsize1),1,add(@refcorner[2],@plotsize1)))
		assign(@corner4,array(add(@refcorner[0],@plotsize1),1,@refcorner[2]))
	)
	return(array(@quadrant,@corner1,@corner2,@corner3,@corner4,@spawncorner,@oppositespawncorner))
)

proc(_plotinfo,@coordinate,
	#given a coordinate set, returns information about the corrosponding plot
	assign(@quadrant,_currentquadrant(@coordinate))
	assign(@coord1,_plotcorners(@coordinate)[5])
	assign(@coord2,_plotcorners(@coordinate)[6])
	assign(@address,_find_plot_address(@coord2))
	assign(@realaddress,_format_plot_address(@address))
	assign(@owner,_get_plot_owner(@realaddress))
	assign(@memberarray,_get_plot_members(@realaddress))
	assign(@guestarray,_get_plot_guests(@realaddress))
	return(array(@quadrant,@coord1,@coord2,@realaddress,@owner,@memberarray,@guestarray))
)

proc(_currentquadrant,@locarray,
	#given a coordinate set, returns the quadrant that coordinate is in
	assign(@x,@locarray[0])
	assign(@z,@locarray[2])
	if(and(not(lt(@x,0)),not(lt(@z,0))),assign(@quadrant,1))
	if(and(not(lt(@x,0)),lt(@z,0)),assign(@quadrant,2))
	if(and(lt(@x,0),lt(@z,0)),assign(@quadrant,3))
	if(and(lt(@x,0),not(lt(@z,0))),assign(@quadrant,4))
	assign(@return,@quadrant)
	return(@return)
)

proc(_find_plot_address,@secondcornerlocarray,
	#given the furthest coordinate from spawn within a plot, returns the address array of corrosponding plot
	include('/includes/options.ms')
	assign(@position,@secondcornerlocarray)
	assign(@posx,@position[0])
	assign(@posy,@position[1])
	assign(@posz,@position[2])
	assign(@quadrant,_currentquadrant(@position))
	assign(@plot_addr_Q,@quadrant)
	if(
		equals(@quadrant,1),
			assign(@plot_addr_X,divide(@position[0],@plotsize))
			assign(@plot_addr_Y,divide(@position[2],@plotsize))
	)
	if(
		equals(@quadrant,2),
			assign(@plot_addr_X,divide(@position[0],@plotsize))
			assign(@plot_addr_Y,divide(add(@position[2],1),@plotsize))
	)
	if(
		equals(@quadrant,3),
			assign(@plot_addr_X,divide(add(@position[0],1),@plotsize))
			assign(@plot_addr_Y,divide(add(@position[2],1),@plotsize))
	)
	if(
		equals(@quadrant,4),
			assign(@plot_addr_X,divide(add(@position[0],1),@plotsize))
			assign(@plot_addr_Y,divide(@position[2],@plotsize))
	)
	assign(@plot_addr_X,abs(@plot_addr_X))
	assign(@plot_addr_Y,abs(@plot_addr_Y))
	assign(@plot_addr_X,ceil(@plot_addr_X))
	assign(@plot_addr_Y,ceil(@plot_addr_Y))
	return(array(@plot_addr_Q,@plot_addr_X,@plot_addr_Y))
)

proc(_format_plot_address,@plotaddressarray,
	#give a plot address array, returns formatted plot address
	assign(@plot_addr_Q,@plotaddressarray[0])
	assign(@plot_addr_X,@plotaddressarray[1])
	assign(@plot_addr_Y,@plotaddressarray[2])
	if(
		lt(
			length(@plot_addr_X),2),
				assign(@plot_addr_X,(concat('0',@plotaddressarray[1]))),
				assign(@plot_addr_X,@plotaddressarray[1])
	)
	if(
		lt(
			length(@plot_addr_Y),2),
				assign(@plot_addr_Y,(concat('0',@plotaddressarray[2]))),
				assign(@plot_addr_Y,@plotaddressarray[2])
	)
	return(concat(@plot_addr_Q,@plot_addr_X,@plot_addr_Y))
)

proc(_Generate_Plot,@locarray,@colorarray,
	include('/includes/options.ms')
	assign(@corner1,_plotcorners(@locarray)[1])
	assign(@corner2,_plotcorners(@locarray)[3])
	_generate_plotchunks(@corner1,@corner2,@colorarray)
	_generate_plotborder(@corner1,@corner2)
	if(
		equals(@plotbedrock,1),
		_generate_plotbedrock(@corner1,@corner2)
	)
	run('//sel')
	run('/!')
)

proc(_generate_plotchunks,@corner1,@corner2,@colorarray,
	include('/includes/options.ms')
	assign(@timestostack,divide(@plotsize,16))
	assign(@timestostack,subtract(@timestostack,1))
	assign(@chunkcorner1,@corner1)
	assign(@chunkcorner2,array(add(@corner1[0],15),@corner1[1],add(@corner1[2],15)))
	_load_chunkpattern(@chunkcorner1,@chunkcorner2,@colorarray)
	run(concat('//stack ',@timestostack,' s'))
	run(concat('//expand ',multiply(@timestostack,16),' s'))
	run(concat('//stack ',@timestostack,' w'))
)

proc(_load_chunkpattern,@corner1,@corner2,@colorarray,
	include('/includes/options.ms')
	assign(@color1,@colorarray[0])
	assign(@color2,@colorarray[1])
	assign(@color3,@colorarray[2])
	assign(@x1,@corner1[0])
	assign(@x2,@corner2[0])
	assign(@y1,@corner1[1])
	assign(@y2,@corner2[1])
	assign(@z1,@corner1[2])
	assign(@z2,@corner2[2])
	assign(@corner3,array(add(@x1,15),@y1,@z1))
	assign(@corner4,array(@x1,@y1,add(@z1,15)))
	sk_pos1(@corner1)
	sk_pos2(@corner2)
	run(concat('//set ',@color1))
	sk_pos2(@corner3)
	run(concat('//set ',@color2))
	sk_pos2(@corner4)
	run(concat('//set ',@color2))
	sk_pos1(@corner2)
	run(concat('//set ',@color2))
	sk_pos2(@corner3)
	run(concat('//set ',@color2))
	set_block_at(@corner1,@color3)
	set_block_at(@corner2,@color3)
	set_block_at(@corner3,@color3)
	set_block_at(@corner4,@color3)
	if(equals(@plotglowstone,1),
		set_block_at(add(@corner1[0],1),1,add(@corner1[2],1),89)
		set_block_at(subtract(@corner2[0],1),1,subtract(@corner2[2],1),89)
		set_block_at(subtract(@corner3[0],1),1,add(@corner3[2],1),89)
		set_block_at(add(@corner4[0],1),1,subtract(@corner4[2],1),89)
	)
	sk_pos1(@corner1)
	sk_pos2(@corner2)
)

proc(_generate_plotborder,@corner1,@corner2,
	include('/includes/options.ms')
	assign(@corner1,array(@corner1[0],'1',@corner1[2]))
	assign(@corner2,array(@corner2[0],'1',@corner2[2]))
	sk_pos1(@corner1)
	sk_pos2(@corner2)
	run(concat('//walls '@plotbordermaterial))
	run(concat('//stack ',1,' u'))
	run(concat('//stack ',2,' u'))
	run(concat('//stack ',3,' u'))
)

proc(_generate_plotbedrock,@corner1,@corner2,
	assign(@corner1,array(@corner1[0],'0',@corner1[2]))
	assign(@corner2,array(@corner2[0],'0',@corner2[2]))
	sk_pos1(@corner1)
	sk_pos2(@corner2)
)