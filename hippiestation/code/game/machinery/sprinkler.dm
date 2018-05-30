#define SPRINKLER_COOLDOWN 150

/obj/machinery/sprinkler
	name = "sprinkler"
	desc = "Emergency sprinkler that converts water into non-slip firefighting foam used for containing fires."
	icon = 'hippiestation/icons/obj/machines/sprinkler.dmi'
	icon_state = "sprinkler"
	anchored = TRUE
	max_integrity = 250
	integrity_failure = 100
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 80)
	var/detecting = TRUE
	resistance_flags = FIRE_PROOF
	var/last_spray = 0
	var/uses = 10
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	plane = FLOOR_PLANE

/obj/machinery/sprinkler/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It has <b>[uses]</b> uses of foam remaining.</span>")

/obj/machinery/sprinkler/temperature_expose(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C + 500 && (last_spray+FIREALARM_COOLDOWN < world.time) && detecting && !stat)
		spray()
	..()

/obj/machinery/sprinkler/proc/spray()
	if(!is_operational() && (last_spray+SPRINKLER_COOLDOWN < world.time))
		return
	if(!uses)
		return

	last_spray = world.time
	detecting = FALSE
	var/obj/effect/foam_container/A = new (get_turf(src))
	playsound(src,'sound/items/syringeproj.ogg',40,1)
	uses--
	A.Smoke()

/obj/machinery/sprinkler/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(obj_integrity > 0 && !(stat & BROKEN) && detecting)
			if(prob(33))
				spray()

/obj/machinery/sprinkler/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	if(istype(W, /obj/item/wrench))
		detecting = !detecting
		if(src.detecting)
			user.visible_message("[user] has reset [src]'s nozzle.", "<span class='notice'>You reset [src]'s nozzle.</span>")
		else
			user.visible_message("[user] has opened [src]'s nozzle!", "<span class='notice'>You open [src]'s nozzle!</span>")
			if(last_spray+SPRINKLER_COOLDOWN < world.time)
				spray()
		return
		W.play_tool_sound(src)
	if(istype(W,/obj/item/reagent_containers/glass))
		if(uses<10)
			if(W.reagents.has_reagent("water", 50))
				uses++
				W.reagents.remove_reagent("water", 50)
				user.visible_message("[user] has partly filled [src].", "<span class='notice'>You partly fill [src]. It now has <b>[uses]</b> uses of foam remaining.</span>")
			else
				to_chat(user, "<span class='notice'>This machine only accepts water.</span>")
		else
			to_chat(user, "<span class='notice'>[src] is full!</span>")
		return
	return ..()


/obj/effect/foam_container
	name = "resin container"
	desc = "A compacted ball of expansive fire fighting foam, used to combat fires."
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = PASSTABLE

/obj/effect/foam_container/proc/Smoke()
	var/obj/effect/particle_effect/foam/firefighting/F = new /obj/effect/particle_effect/foam/firefighting(get_turf(loc))
	F.amount = 5
	playsound(src,'sound/effects/bamf.ogg',100,1)
	qdel(src)


/datum/crafting_recipe/sprinkler
	name = "Water Sprinkler"
	result = /obj/machinery/sprinkler
	time = 50
	reqs = list(/obj/item/stack/sheet/metal = 1,
				  /obj/item/stack/sheet/glass = 1,
				  /obj/item/reagent_containers/glass/beaker = 1)
	tools = list(/obj/item/weldingtool,
		         /obj/item/wrench)
	category = CAT_MISC