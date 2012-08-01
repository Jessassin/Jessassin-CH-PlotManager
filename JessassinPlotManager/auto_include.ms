# +----------------------------------------------+
# | Jessassin's Plot Management System           |
# | Auto_Include.ms                              |
# +----------------------------------------------+

proc(_jessassin_plotmanager_init,@player,assign(@force,'no'),
	include('/includes/options.ms')
	assign(@defaultplotcount,@jessassindefaultplotcount)
	if(
		not(has_value(concat(@player,'_plotcount'))),
			store_value(concat(@player,'_plotcount'),0)
	)
	if(
		not(has_value(concat(@player,'_maxplotcount'))),
			store_value(concat(@player,'_maxplotcount'),@defaultplotcount)
	)
#	if(
#		not(has_value(concat(@player,'_plotarray'))),
#			store_value(concat(@player,'_plotarray'),'')
#	)
	if(
		equals(@force,force),
#			store_value(concat(@player,'_plotarray'),'')
			store_value(concat(@player,'_maxplotcount'),@defaultplotcount)
			store_value(concat(@player,'_plotcount'),0)
	)
)

proc(_jessassin_get_player_plotinfo,@player,
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

proc(_jessassin_get_plot_owner,@plotaddress,
	if(
		has_value(concat(@plotaddress,'_owner')),
			assign(@plotowner,get_value(concat(@plotaddress,'_owner')))
	)
	return(@plotowner)
)

proc(_jessassin_get_plot_members,@plotaddress,
	if(
		has_value(concat(@plotaddress,'_memberarray')),
			assign(@plotmembers,get_value(concat(@plotaddress,'_memberarray')))
	)
	return(@plotmembers)
)

#proc(_jessassin_initializeplot,@address,
#	if(
#		not(has_value(concat(@address,'_owner'),
#			store_value('')
#	)
#	if(
#		not(has_value()),
#			store_value()
#	)
#)

proc(_jessassin_claimplot,@coords,@player,
	assign(@playerinfo,_jessassin_get_player_plotinfo(@player))
	assign(@plotinfo,_jessassin_plotinfo(@coords))
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
		msg('pushing array')
		assign(@newownedplotarray,@ownedplotarray)
		array_push(@newownedplotarray,@plotaddress),
		msg('assigning array')
		msg(@newplotarray,@plotaddress)
		assign(@newownedplotarray,array(@plotaddress))
	)
	#msg()
	#msg(@ownedplotarray)
	#msg(@ownedplotcount)
	#msg(@maxplotcount)
	#msg()
	#msg(@newownedplotarray)
	#msg(@newownedplotcount)
	#msg(@newmaxplotcount)
	#msg()
	#write to persistance DB
	store_value(concat(@player,'_plotcount'),@newownedplotcount)
	store_value(concat(@player,'_maxplotcount'),@newmaxplotcount)
	store_value(concat(@player,'_plotarray'),@newownedplotarray)
	store_value(concat(@plotaddress,'_owner'),@player)
)

proc(_jessassin_unclaimplot,@coords,@player,
	assign(@playerinfo,_jessassin_get_player_plotinfo(@player))
	assign(@plotinfo,_jessassin_plotinfo(@coords))
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
#	if(
#		gt(length(@ownedplotarray),0),
#		msg('pushing array')
#		assign(@newownedplotarray,@ownedplotarray)
#		array_push(@newownedplotarray,@plotaddress),
#		msg('assigning array')
#		msg(@newplotarray,@plotaddress)
#		assign(@newownedplotarray,array(@ownedplotarray))
#	)
	assign(@newownedplotarray,@ownedplotarray)
	assign(@counter,0)
	foreach(@newownedplotarray,@plot,
		if(equals(@plot,@plotaddress),
			assign(@removeindex,@counter)
		)
		assign(@counter,add(@counter,1))
	)
	array_remove(@newownedplotarray,@removeindex)
	#msg()
	#msg(@ownedplotarray)
	#msg(@ownedplotcount)
	#msg(@maxplotcount)
	#msg()
	#msg(@newownedplotarray)
	#msg(@newownedplotcount)
	#msg(@newmaxplotcount)
	#msg()
	#write to persistance DB
	store_value(concat(@player,'_plotcount'),@newownedplotcount)
	store_value(concat(@player,'_maxplotcount'),@newmaxplotcount)
	store_value(concat(@player,'_plotarray'),@newownedplotarray)
	store_value(concat(@plotaddress,'_owner'),'')
)

proc(_jessassin_plot_address_coordinates,@address,
	
)

proc(_jessassin_plotcorners,@locationarray,
	include('/includes/options.ms')
	assign(@plotsize,@jessassinplotsize)
	assign(@plotsize1,subtract(@plotsize,1))
	assign(@quadrant,_jessassin_currentquadrant(@locationarray))
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

proc(_jessassin_plotinfo,@coordinate,
	assign(@quadrant,_jessassin_currentquadrant(@coordinate))
	assign(@coord1,_jessassin_plotcorners(@coordinate)[5])
	assign(@coord2,_jessassin_plotcorners(@coordinate)[6])
	assign(@address,_jessassin_find_plot_address(@coord2))
	assign(@realaddress,_jessassin_format_plot_address(@address))
	assign(@owner,_jessassin_get_plot_owner(@realaddress))
	assign(@memberarray,_jessassin_get_plot_members(@realaddress))
	return(array(@quadrant,@coord1,@coord2,@realaddress,@owner,@memberarray))
)

proc(_jessassin_currentquadrant,@locarray,
	assign(@x,@locarray[0])
	assign(@z,@locarray[2])
	if(and(not(lt(@x,0)),not(lt(@z,0))),assign(@quadrant,1))
	if(and(not(lt(@x,0)),lt(@z,0)),assign(@quadrant,2))
	if(and(lt(@x,0),lt(@z,0)),assign(@quadrant,3))
	if(and(lt(@x,0),not(lt(@z,0))),assign(@quadrant,4))
	assign(@return,@quadrant)
	return(@return)
)

proc(_jessassin_find_plot_address,@secondcornerlocarray,
	include('/includes/options.ms')
	assign(@position,@secondcornerlocarray)
	assign(@posx,@position[0])
	assign(@posy,@position[1])
	assign(@posz,@position[2])
	assign(@quadrant,_jessassin_currentquadrant(@position))
	assign(@plot_addr_Q,@quadrant)
	if(
		equals(@quadrant,1),
			assign(@plot_addr_X,divide(@position[0],@jessassinplotsize))
			assign(@plot_addr_Y,divide(@position[2],@jessassinplotsize))
	)
	if(
		equals(@quadrant,2),
			assign(@plot_addr_X,divide(@position[0],@jessassinplotsize))
			assign(@plot_addr_Y,divide(add(@position[2],1),@jessassinplotsize))
	)
	if(
		equals(@quadrant,3),
			assign(@plot_addr_X,divide(add(@position[0],1),@jessassinplotsize))
			assign(@plot_addr_Y,divide(add(@position[2],1),@jessassinplotsize))
	)
	if(
		equals(@quadrant,4),
			assign(@plot_addr_X,divide(add(@position[0],1),@jessassinplotsize))
			assign(@plot_addr_Y,divide(@position[2],@jessassinplotsize))
	)
	assign(@plot_addr_X,abs(@plot_addr_X))
	assign(@plot_addr_Y,abs(@plot_addr_Y))
	assign(@plot_addr_X,ceil(@plot_addr_X))
	assign(@plot_addr_Y,ceil(@plot_addr_Y))
	return(array(@plot_addr_Q,@plot_addr_X,@plot_addr_Y))
)

proc(_jessassin_format_plot_address,@plotaddressarray,
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

proc(_Jessassin_Generate_Plot,@locarray,@colorarray,
	include('/includes/options.ms')
	assign(@corner1,_jessassin_plotcorners(@locarray)[1])
	assign(@corner2,_jessassin_plotcorners(@locarray)[3])
#	run('//fast')
	_jessassin_generate_plotchunks(@corner1,@corner2,@colorarray)
	_jessassin_generate_plotborder(@corner1,@corner2)
	if(
		equals(@jessassinplotbedrock,1),
		_jessassin_generate_plotbedrock(@corner1,@corner2)
	)
	run('//sel')
	run('/!')
#	run('//fast')
)

proc(_jessassin_generate_plotchunks,@corner1,@corner2,@colorarray,
	include('/includes/options.ms')
#	msg('Generating Chunks')
	assign(@timestostack,divide(@jessassinplotsize,16))
	assign(@timestostack,subtract(@timestostack,1))
#	msg('Stacking: ',@timestostack)
	assign(@chunkcorner1,@corner1)
	assign(@chunkcorner2,array(add(@corner1[0],15),@corner1[1],add(@corner1[2],15)))
	_jessassin_load_chunkpattern(@chunkcorner1,@chunkcorner2,@colorarray)
	run(concat('//stack ',@timestostack,' s'))
	run(concat('//expand ',multiply(@timestostack,16),' s'))
	run(concat('//stack ',@timestostack,' w'))
#	msg('Done!')
)

proc(_jessassin_load_chunkpattern,@corner1,@corner2,@colorarray,
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
	if(equals(@jessassinplotglowstone,1),
		set_block_at(add(@corner1[0],1),1,add(@corner1[2],1),89)
		set_block_at(subtract(@corner2[0],1),1,subtract(@corner2[2],1),89)
		set_block_at(subtract(@corner3[0],1),1,add(@corner3[2],1),89)
		set_block_at(add(@corner4[0],1),1,subtract(@corner4[2],1),89)
	)
	sk_pos1(@corner1)
	sk_pos2(@corner2)
)

proc(_jessassin_generate_plotborder,@corner1,@corner2,
	include('/includes/options.ms')
#	msg('Generating Plot Border!')
	assign(@corner1,array(@corner1[0],'1',@corner1[2]))
	assign(@corner2,array(@corner2[0],'1',@corner2[2]))
	sk_pos1(@corner1)
	sk_pos2(@corner2)
	run(concat('//walls '@jessassinplotbordermaterial))
	run(concat('//stack ',1,' u'))
	run(concat('//stack ',2,' u'))
	run(concat('//stack ',3,' u'))
#	msg('Done!')
)

proc(_jessassin_generate_plotbedrock,@corner1,@corner2,
#	msg('Generating bedrock!')
	assign(@corner1,array(@corner1[0],'0',@corner1[2]))
	assign(@corner2,array(@corner2[0],'0',@corner2[2]))
	sk_pos1(@corner1)
	sk_pos2(@corner2)
#	run('//set 7')
#	msg('Done!')
)