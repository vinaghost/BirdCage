#include <bc_core>
#include <xs>

new g_name[] = "alo"
new g_sprite
new /*Float:toado[3],*/ mynpctest
//new Float:g_icon_delay[33]
public plugin_init() { 
	register_plugin("Sprites Show", "1.5", "KRoTaL") 
	
	new ent = create_entity("info_target") 
	
	if(ent) 
	{ 
		entity_set_string(ent, EV_SZ_classname, g_name) 
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 0.1) 
	} 
	register_think(g_name,"taodangsuynghi")
	
	register_clcmd("say /testnpc", "test")
}
public plugin_precache() {
	precache_model("models/bc/npc/bc_chest.mdl")
	g_sprite = precache_model("sprites/bc/test_ahihi.spr")
}
public test(id) {
	Create_Npc(id)
}
	
Create_Npc(id, Float:flOrigin[3]= { 0.0, 0.0, 0.0 }, Float:flAngle[3]= { 0.0, 0.0, 0.0 } ) {
	new iEnt = create_entity("info_target");
	
	entity_set_string(iEnt, EV_SZ_classname, "ahihi");
		
	if(id)
	{
		entity_get_vector(id, EV_VEC_origin, flOrigin);
		entity_set_origin(iEnt, flOrigin);
		create_title(flOrigin)
		//copytoado(flOrigin, toado)
		flOrigin[2] += 80.0;
		entity_set_origin(id, flOrigin);
		
		entity_get_vector(id, EV_VEC_angles, flAngle);
		flAngle[0] = 0.0;
	}
	else 
	{
		entity_set_origin(iEnt, flOrigin);
		create_title(flOrigin)
	}
	
	
	
	entity_set_vector(iEnt, EV_VEC_angles, flAngle);
	
	entity_set_model(iEnt, "models/bc/npc/bc_chest.mdl");
	entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_PUSHSTEP);
	entity_set_int(iEnt, EV_INT_solid, SOLID_BBOX);
	
	new Float: mins[] =  {-12.0, -12.0, 0.0}
	new Float: maxs[] = {12.0, 12.0, 75.0}
	entity_set_size(iEnt, mins, maxs);
	
	
	entity_set_byte(iEnt,EV_BYTE_controller1,125);
	// entity_set_byte(ent,EV_BYTE_controller2,125);
	// entity_set_byte(ent,EV_BYTE_controller3,125);
	// entity_set_byte(ent,EV_BYTE_controller4,125);
	
	drop_to_floor(iEnt);
	
	mynpctest = iEnt
	
	//entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.01)
}
create_title(Float:origin[3]) {
	new iEnt = create_entity("info_target");
	
	entity_set_string(iEnt, EV_SZ_classname, "ahuhu");
	origin[0] -= 10.0;
	origin[2] += 40.0;
	entity_set_origin(iEnt, origin);
	set_rendering(iEnt, kRenderFxNone, 0, 0, 0, kRenderTransAdd, 255) 
	entity_set_model(iEnt, "sprites/bc/test_ahihi.spr");
}
/*
public client_PostThink(id)
{
	if (!is_alive(id) || get_progress() != START)r
		return
	if(g_icon_delay[id] + 0.1 > get_gametime())
		return	
}
public client_connect(id) {
	g_icon_delay[id] = get_gametime()
}*/

