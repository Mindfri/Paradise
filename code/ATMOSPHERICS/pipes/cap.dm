/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/obj/pipes_and_stuff/atmospherics/atmos/pipes.dmi'
	icon_state = "cap"
	level = 2

	volume = 35

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/atmospherics/node

/obj/machinery/atmospherics/pipe/cap/New()
	..()
	initialize_directions = dir

/obj/machinery/atmospherics/pipe/cap/hide(i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? INVISIBILITY_MAXIMUM : 0
	update_icon()

/obj/machinery/atmospherics/pipe/cap/pipeline_expansion()
	return list(node)

/obj/machinery/atmospherics/pipe/cap/process_atmos()
	if(!parent)
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/cap/Destroy()
	. = ..()
	if(node)
		node.disconnect(src)
		node.defer_build_network()
		node = null

/obj/machinery/atmospherics/pipe/cap/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node = null

	update_icon()

	..()

/obj/machinery/atmospherics/pipe/cap/change_color(new_color)
	..()
	//for updating connected atmos device pipes (i.e. vents, manifolds, etc)
	if(node)
		node.update_underlays()


/obj/machinery/atmospherics/pipe/cap/update_overlays()
	. = ..()
	if(!check_icon_cache())
		return

	alpha = 255
	. += SSair.icon_manager.get_atmos_icon("pipe", , pipe_color, "cap" + icon_connect_type)


/obj/machinery/atmospherics/pipe/cap/atmos_init()
	..()
	for(var/obj/machinery/atmospherics/target in get_step(src, dir))
		if(target.initialize_directions & get_dir(target,src))
			var/c = check_connect_types(target,src)
			if(c)
				target.connected_to = c
				src.connected_to = c
				node = target
				break

	var/turf/T = get_turf(src)			// hide if turf is not intact
	if(!istype(T) || T.transparent_floor)
		return
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"
	plane = GAME_PLANE
	layer = GAS_PIPE_VISIBLE_LAYER

/obj/machinery/atmospherics/pipe/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-scrubbers"
	connect_types = list(3)
	layer = GAS_PIPE_VISIBLE_LAYER + GAS_PIPE_SCRUB_OFFSET
	layer_offset = GAS_PIPE_SCRUB_OFFSET
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-supply"
	connect_types = list(2)
	layer = GAS_PIPE_VISIBLE_LAYER + GAS_PIPE_SUPPLY_OFFSET
	layer_offset = GAS_PIPE_SUPPLY_OFFSET
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap"
	alpha = 128
	plane = FLOOR_PLANE
	layer = GAS_PIPE_HIDDEN_LAYER

/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-scrubbers"
	connect_types = list(3)
	layer = GAS_PIPE_HIDDEN_LAYER + GAS_PIPE_SCRUB_OFFSET
	layer_offset = GAS_PIPE_SCRUB_OFFSET
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-supply"
	connect_types = list(2)
	layer = GAS_PIPE_HIDDEN_LAYER + GAS_PIPE_SUPPLY_OFFSET
	layer_offset = GAS_PIPE_SUPPLY_OFFSET
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE
