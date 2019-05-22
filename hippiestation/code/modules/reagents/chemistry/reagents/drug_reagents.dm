/datum/reagent/drug/burpinate
    name = "Burpinate"
    id = "burpinate"
    description = "They call me gaseous clay."
    reagent_state = LIQUID
    color = "#bfe8a7" // rgb: 191, 232, 167
    metabolization_rate = 0.9 * REAGENTS_METABOLISM
    taste_description = "wet hot dogs"

/datum/reagent/drug/burpinate/on_mob_life(mob/living/M)
    if(ishuman(M))
        var/mob/living/carbon/human/H = M
        if(prob(5+(current_cycle*0.6))) //burping intensifies
            H.emote("burp")
            if(prob(5))
                to_chat(H, "<span class='danger'>You feel your bloated stomach rumble with gas.</span>")

        if(current_cycle>90) //chance to burp = 55% (you can't stop burping)
            if(prob(5))
                to_chat(H, "<span class='danger'>Your throat is sore from all the gas coming out!</span>")
    return ..()

/datum/reagent/drug/fartium
	name = "Fartium"
	id = "fartium"
	description = "A chemical compound that promotes concentrated production of gas in your groin area."
	color = "#8A4B08" // rgb: 138, 75, 8
	reagent_state = LIQUID
	overdose_threshold = 30
	addiction_threshold = 50

/datum/reagent/drug/fartium/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/butt/B = locate() in H.internal_organs
		if(prob(7))
			if(B)
				H.emote("fart")
			else
				to_chat(H, "<span class='danger'>Your stomach rumbles as pressure builds up inside of you.</span>")
				H.adjustToxLoss(1*REM)
	return ..()

/datum/reagent/drug/fartium/overdose_process(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/butt/B = locate() in H.internal_organs
		if(prob(9))
			if(B)
				H.emote("fart")
			else
				to_chat(H, "<span class='danger'>Your stomach hurts a bit as pressure builds up inside of you.</span>")
				H.adjustToxLoss(2*REM)
	return ..()

/datum/reagent/drug/fartium/addiction_act_stage1(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/butt/B = locate() in H.internal_organs
		if(prob(11))
			if(B)
				H.emote("fart")
			else
				to_chat(H, "<span class='danger'>Your stomach hurts as pressure builds up inside of you.</span>")
				H.adjustToxLoss(3*REM)
	return ..()

/datum/reagent/drug/fartium/addiction_act_stage2(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/butt/B = locate() in H.internal_organs
		if(prob(13))
			if(B)
				H.emote("fart")
			else
				to_chat(H, "<span class='danger'>Your stomach hurts a lot as pressure builds up inside of you.</span>")
				H.adjustToxLoss(4*REM)
	return ..()

/datum/reagent/drug/fartium/addiction_act_stage3(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/butt/B = locate() in H.internal_organs
		if(prob(15))
			if(B)
				if(prob(2) && !B.loose) H.emote("superfart")
				else H.emote("fart")
			else
				to_chat(H, "<span class='danger'>Your stomach hurts too much as pressure builds up inside of you.</span>")
				H.adjustToxLoss(5*REM)
	return ..()

/datum/reagent/drug/fartium/addiction_act_stage4(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/butt/B = locate() in H.internal_organs
		if(prob(15))
			if(B)
				if(prob(5) && !B.loose) H.emote("superfart")
				else H.emote("fart")
			else
				to_chat(H, "<span class='danger'>Your stomach hurts too much as pressure builds up inside of you.</span>")
				H.adjustToxLoss(6*REM)
	return ..()

/datum/reagent/drug/nicotine
	description = "Slightly increases stamina regeneration and reduces hunger. If overdosed it will deal toxin and oxygen damage."

/datum/reagent/drug/nicotine/on_mob_life(mob/living/M)
	if(prob(1))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(M, "<span class='notice'>[smoke_message]</span>")
	M.adjustStaminaLoss(-0.5*REM, 0)
	return FINISHONMOBLIFE(M)

/datum/reagent/drug/crank/on_mob_life(mob/living/M)
	var/high_message = pick("You feel jittery.", "You feel like you gotta go fast.", "You feel like you need to step it up.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-20, 0)
	M.AdjustParalyzed(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustToxLoss(2)
	M.adjustBrainLoss(1*REM)
	return FINISHONMOBLIFE(M)

/datum/reagent/drug/methamphetamine
	description = "Reduces stun times by about 300% and allows the user to quickly recover stamina while dealing a small amount of Brain damage. Breaks down slowly into histamine and hits the user with a large amount of histamine if they are stunned. Reacts badly with Ephedrine. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/M)
	var/high_message = pick("You feel hyper.", "You feel like you're unstoppable!", "You feel like you can take on the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.reagents.remove_reagent("diphenhydramine",2) //Greatly increases rate of decay
	if(M.IsStun() || M.IsParalyzed() || M.IsUnconscious())
		M.AdjustStun(-40, 0)
		M.AdjustParalyzed(-40, 0)
		M.AdjustUnconscious(-40, 0)
		var/amount2replace = rand(2,6)
		M.reagents.add_reagent("histamine",amount2replace)
		M.reagents.remove_reagent("methamphetamine",amount2replace)
	M.adjustStaminaLoss(-2, 0)
	M.Jitter(2)
	M.adjustBrainLoss(0.25)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
		M.reagents.add_reagent("histamine", rand(1,5))
	return FINISHONMOBLIFE(M)

/datum/reagent/drug/bath_salts/on_mob_life(mob/living/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.add_movespeed_modifier(id, update=TRUE, priority=100, multiplicative_slowdown=-2, blacklisted_movetypes=(FLYING|FLOATING))
	M.AdjustUnconscious(-100, 0)
	M.AdjustStun(-100, 0)
	M.AdjustParalyzed(-100, 0)
	M.adjustStaminaLoss(-100, 0)
	M.adjustBrainLoss(5)
	M.adjustToxLoss(4)
	M.hallucination += 20
	if((M.mobility_flags & MOBILITY_MOVE) && !istype(M.loc, /atom/movable))
		step(M, pick(GLOB.cardinals))
		step(M, pick(GLOB.cardinals))
	if(prob(40))
		var/obj/item/I = M.get_active_held_item()
		if(I)
			M.dropItemToGround(M.get_active_held_item())
	return FINISHONMOBLIFE(M)

/datum/reagent/drug/bath_salts/on_mob_delete(mob/living/M)
	if (istype(M))
		M.remove_movespeed_modifier(id)
	..()

/datum/reagent/drug/flipout
	name = "Flipout"
	id = "flipout"
	description = "A chemical compound that causes uncontrolled and extremely violent flipping."
	color = "#ff33cc" // rgb: 255, 51, 204
	reagent_state = LIQUID
	overdose_threshold = 40
	addiction_threshold = 30


/datum/reagent/drug/flipout/on_mob_life(mob/living/M)
	var/high_message = pick("You have the uncontrollable, all consuming urge to FLIP!.", "You feel as if you are flipping to a higher plane of existence.", "You just can't stop FLIPPING.")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(80))
			H.SpinAnimation(10,1)
		if(prob(10))
			M << "<span class='notice'>[high_message].</span>"

	..()
	return

/datum/reagent/drug/flipout/overdose_process(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.SpinAnimation(16,100)
		if(prob(70))
			H.Dizzy(20)
			if((M.mobility_flags & MOBILITY_MOVE) && !istype(M.loc, /atom/movable))
				for(var/i = 0, i < 4, i++)
				step(M, pick(GLOB.cardinals))
		if(prob(15))
			M << "<span class='danger'>The flipping is so intense you begin to tire </span>"
			H.confused +=4
			M.adjustStaminaLoss(10)
			H.transform *= -1
	..()
	return

/datum/reagent/drug/flipout/addiction_act_stage1(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(85))
			H.SpinAnimation(12,1)
		else
			H.Dizzy(16)
	..()

/datum/reagent/drug/flipout/addiction_act_stage2(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(90))
			H.SpinAnimation(10,3)
		else
			H.Dizzy(20)
			M.adjustStaminaLoss(25)
	..()

/datum/reagent/drug/flipout/addiction_act_stage3(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(95))
			H.SpinAnimation(7,20)
		else
			H.Dizzy(30)
			M.adjustStaminaLoss(40)
	..()

/datum/reagent/drug/flipout/addiction_act_stage4(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.SpinAnimation(2,100)
		if(prob(10))
			M << "<span class='danger'>Your flipping has become so intense you've become an improvised generator </span>"
			H.Dizzy(25)
			M.electrocute_act(rand(1,5), 1, 1)
			playsound(M, "sparks", 50, 1)
			H.emote("scream")
			H.Jitter(-100)

		else
			H.Dizzy(60)
	..()

/datum/reagent/drug/flipout/reaction_obj(obj/O, reac_volume)
	if(istype(O,/obj))
		O.SpinAnimation(16,40)

/datum/reagent/drug/yespowder
	name = "Yes Powder"
	id = "yespowder"
	description = "Powder that makes you say yes."
	color = "#fffae0"
	reagent_state = LIQUID

/datum/reagent/drug/yespowder/on_mob_life(mob/living/M)
	var/high_message = pick("Agreement fills your mind.", "'No' is so last year. 'Yes' is in.", "Yes.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	if(prob(20))
		M.say("Yes.", forced = "yes powder")
	..()

/datum/reagent/drug/pupupipi
	name = "Sweet Brown"
	id = "sweetbrown"
	description = "A fetid concoction often huffed or drank by vagrants and bums. High dosages have... interesting effects."
	color = "#602101" // rgb: 96, 33, 1
	reagent_state = LIQUID
	overdose_threshold = 100
	addiction_threshold = 50 // doesn't do shit though

/datum/reagent/drug/pupupipi/on_mob_life(mob/living/M)
	if(prob(5))
		var/high_message = pick("You need mo' o' dat sweet brown juice...", "Your guts tingle...", "You feel lightheaded...")
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.Jitter(30)
	if(prob(15)) //once every six-ish ticks. is that ok?
		M.emote("burp")
	..()

/datum/reagent/drug/pupupipi/overdose_process(mob/living/carbon/human/H)
	CHECK_DNA_AND_SPECIES(H)
	H.setBrainLoss(30)
	if(ishuman(H))
		to_chat(H, "<span class= 'userdanger'>Oh shit!</span>")
		H.set_species(/datum/species/krokodil_addict)
	..()

/datum/reagent/drug/grape_blast
	name = "Grape Blast"
	id = "grapeblast"
	description = "A juice of a very special fruit, concentrated and sold at your local A1 vendor."
	color = "#ffffe6"
	reagent_state = LIQUID
	taste_description = "artificial grape"
	var/obj/effect/hallucination/simple/druggy/brain
	var/list/spook_images = list()

/datum/reagent/drug/grape_blast/proc/create_brain(mob/living/carbon/C)
	var/turf/where = locate(C.x + pick(-1, 1), C.y + pick(-1, 1), C.z)
	brain = new(where, C)

/datum/reagent/drug/grape_blast/on_mob_life(mob/living/carbon/H)
	if(!H && !H.hud_used)
		return
	var/high_message
	var/list/screens = list(H.hud_used.plane_masters["[FLOOR_PLANE]"], H.hud_used.plane_masters["[GAME_PLANE]"], H.hud_used.plane_masters["[LIGHTING_PLANE]"], H.hud_used.plane_masters["[CAMERA_STATIC_PLANE ]"])
	switch(current_cycle)
		if(1 to 20)
			high_message = pick("Holy shit, I feel so fucking happy...", "What the fuck is going on?", "Where am I?")
			if(prob(15))
				H.dna.add_mutation(SMILE)
			else if(prob(30)) //blurry eyes and talk like an idiot
				H.blur_eyes(2)
				H.derpspeech++
		if(31 to INFINITY)
			high_message = pick("I feel like I'm flying!", "I feel something swimming inside my lungs....", "I can see the words I'm saying...")
			if(prob(10))
				var/rotation = min(round(current_cycle/4), 90)
				for(var/obj/screen/plane_master/whole_screen in screens)
					if(prob(60))
						animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 50, easing = CIRCULAR_EASING)
						animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = BACK_EASING)
					else
						animate(whole_screen, transform = matrix(rotation*4, MATRIX_ROTATE), time = 120, easing = QUAD_EASING)
						animate(transform = matrix()*2, time = 120, easing = QUAD_EASING)
			else if(prob(10))
				for(var/obj/screen/plane_master/whole_screen in screens)
					whole_screen.filters += filter(type="wave", x=20*rand() - 20, y=20*rand() - 20, size=rand()*0.1, offset=rand()*0.5, flags = WAVE_BOUNDED)
					animate(whole_screen.filters[whole_screen.filters.len], size = rand(1,3), time = 60, easing = ELASTIC_EASING)
				high_message = pick("Holy shit...", "Reality doesn't exist man.")
				to_chat(H, "<span class='notice'>You feel reality melt away...</span>")
			//else if(prob(10))
			//	trippy_smoke(H)
			else if(prob(5))
				create_brain(H)
			else if(prob(4))
				H.emote("laugh")
				H.say(pick("GRERRKRKRK",";HAHAH I AM SO FUCKING HIGH!!","I AM A BUTTERFLY!!"))
				H.visible_message("<span class='notice'>[H] looks high as fuck!</span>")
			else if(prob(3))
				H.Knockdown(20)
				H.emote("laugh")
				H.say(pick("TURN IT ON!!!","I CAN HEAR VOICES AHAHAHAH","YOU'RE GOKU!!"))
				H.visible_message("<span class='notice'>[H] appears to be on some good drugs!</span>")
	if(prob(5))
		to_chat(H, "<i>You hear your own thoughts... <b>[high_message]</i></b>")
	..()

/datum/reagent/drug/grape_blast/on_mob_delete(mob/living/L)
	cure_autism(L)
	..()

/datum/reagent/drug/grape_blast/proc/cure_autism(mob/living/carbon/C)
	to_chat(C, "<span class='notice'>As the drugs wear off, you feel yourself slowly coming back to reality...</span>")
	C.drowsyness++ //We feel sleepy after going through that trip.
	if(!HAS_TRAIT(C, TRAIT_DUMB))
		C.derpspeech = 0
	if(C && C.hud_used)
		var/list/screens = list(C.hud_used.plane_masters["[FLOOR_PLANE]"], C.hud_used.plane_masters["[GAME_PLANE]"], C.hud_used.plane_masters["[LIGHTING_PLANE]"], C.hud_used.plane_masters["[CAMERA_STATIC_PLANE]"])
		for(var/obj/screen/plane_master/whole_screen in screens)
			animate(whole_screen, transform = matrix(), time = 200, easing = ELASTIC_EASING)
			whole_screen.filters = list()
/*
/datum/reagent/drug/grape_blast/proc/trippy_smoke(mob/living/carbon/C)
	for(var/obj/effect/spook in GLOB.smoke)
		var/image/trippy_image = image(loc = spook)
		if(trippy_image)
			trippy_image = new(spook.loc)
			trippy_image.filters += filter(type="wave", x=40*rand() - 20, y=40*rand() - 20, size=rand(), offset=rand())
			animate(trippy_image.filters[trippy_image.filters.len], size = 5, time = 20)
			spook_images += trippy_image
			if(C.client)
				C.client.images |= spook_images
			addtimer(CALLBACK(src, .proc/stop_trip, C),80)
*/
/datum/reagent/drug/grape_blast/proc/stop_trip(mob/living/carbon/C)
	if(C.client)
		C.client.images -= spook_images

/obj/effect/hallucination/simple/druggy
	name = "Your brain"
	desc = "Don't do drugs kids."
	image_icon = 'icons/obj/surgery.dmi'
	image_state = "brain"

/obj/effect/hallucination/simple/druggy/Initialize()
	. = ..()
	spook()

/obj/effect/hallucination/simple/druggy/proc/spook()
	sleep(20)
	say("This is your brain on drugs.")
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in get_hearers_in_view(6, src))
		if(M.client)
			speech_bubble_recipients.Add(M.client)
	var/image/I = image('icons/mob/talk.dmi', src, "default2", FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, /.proc/flick_overlay, I, speech_bubble_recipients, 30)
	sleep(10)
	animate(src, transform = matrix()*0.75, time = 5)
	QDEL_IN(src, 30)
