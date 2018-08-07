#include <bc_core>
#include <bc_qua>
#include <bc_traiacquy>

#define PLUGIN "BirdCage: Tori Tori no mi"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"


new acquy, active
new Ent
new speed
new Float: Velocity[33][3]
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	acquy = bc_acquy_register("Tori Tori", 50, 25, ZOAN)
	
	do ( Ent = create_entity("info_target") )
	while ( !Ent )
		
	speed = register_cvar("bc_taq_tori_speed", "400")
	
}
public plugin_end() {
	remove_entity(Ent)
}
public bc_taq_kichhoat(id, id_trai) {
	if (id_trai == acquy)
		Set_BitVar(active,id)
}
public bc_taq_end(id, id_trai) {
	if (id_trai == acquy)
	{
		UnSet_BitVar(active, id)
		set_user_gravity(id)
	}
}
public client_PreThink(id) {
	if(is_alive(id)) 
	{
		if ( Get_BitVar(active, id) )
		{
			new Float: xAngles[3]
			new Float: xOrigin[3]
			new button = get_user_button(id)
			
			if(button&IN_FORWARD && button&IN_MOVERIGHT && button & IN_JUMP)  // FORWARD + MOVERIGHT + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] -= 45
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_FORWARD && button & IN_MOVERIGHT && button & IN_DUCK)  // FORWARD + MOVERIGHT + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] -= 45
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_FORWARD && button & IN_MOVELEFT && button & IN_JUMP)  // FORWARD + MOVELEFT + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] += 45
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_FORWARD && button & IN_MOVELEFT && button & IN_DUCK)  // FORWARD + MOVELEFT + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] += 45
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_JUMP && button & IN_MOVERIGHT && button & IN_BACK)  // BACK + MOVERIGHT + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] -= 135
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_BACK && button & IN_MOVERIGHT && button & IN_DUCK)  // BACK + MOVERIGHT + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] -= 135
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_JUMP && button & IN_MOVELEFT && button & IN_BACK)  // BACK + MOVELEFT + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] += 135
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_BACK && button & IN_MOVELEFT && button & IN_DUCK)  // BACK + MOVELEFT + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] += 135
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVERIGHT && button & IN_FORWARD) //  MOVERIGHT  + FORWARD
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 0.0
				xAngles[1] -= 45
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVERIGHT && button & IN_BACK) // MOVERIGHT + BACK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 0.0
				xAngles[1] -= 135
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVELEFT && button & IN_FORWARD) // MOVELEFT + FORWARD
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 0.0
				xAngles[1] += 45
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVELEFT && button & IN_BACK) // MOVELEFT + BACK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 0.0
				xAngles[1] += 135
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_FORWARD && button & IN_JUMP)  // FORWARD + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_FORWARD && button & IN_DUCK)  // FORWARD + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_BACK && button & IN_JUMP)  // BACK + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] += 180
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_BACK && button & IN_DUCK)  // BACK + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] += 180
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}	
			else if(button & IN_MOVERIGHT && button & IN_JUMP)  // MOVERIGHT + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] -= 90
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVERIGHT && button & IN_DUCK)  // MOVERIGHT + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] -= 90
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVELEFT && button & IN_JUMP)  // MOVELEFT + JUMP
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = -45.0
				xAngles[1] += 90
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_MOVELEFT && button & IN_DUCK)  // MOVELEFT + DUCK
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				
				
				xAngles[0] = 45.0
				xAngles[1] += 90
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button & IN_FORWARD) // FORWARD
				VelocityByAim(id, get_pcvar_num(speed) , Velocity[id])
			else if(button & IN_BACK) // BACK
				VelocityByAim(id, -get_pcvar_num(speed) , Velocity[id])
			else if(button&IN_DUCK) // DUCK
			{
				Velocity[id][0] = 0.0
				Velocity[id][1] = 0.0
				Velocity[id][2] = -get_pcvar_num(speed) * 1.0
			}
			else if(button&IN_JUMP) // JUMP
			{
				Velocity[id][0] = 0.0
				Velocity[id][1] = 0.0
				Velocity[id][2] = get_pcvar_num(speed) * 1.0
			}
			else if(button&IN_MOVERIGHT) // MOVERIGHT
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				xAngles[0] = 0.0
				xAngles[1] -= 90
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else if(button&IN_MOVELEFT) // MOVELEFT
			{
				entity_get_vector(id, EV_VEC_v_angle, xAngles)
				entity_get_vector(id, EV_VEC_origin, xOrigin)
				
				xAngles[0] = 0.0
				xAngles[1] += 90
				
				entity_set_origin(Ent, xOrigin)
				entity_set_vector(Ent, EV_VEC_v_angle, xAngles)
				
				VelocityByAim(Ent, get_pcvar_num(speed), Velocity[id])
				
				
			}
			else
			{
				Velocity[id][0] = 0.0
				Velocity[id][1] = 0.0
				Velocity[id][2] = 0.0
			}
			
			
			entity_set_vector(id, EV_VEC_velocity, Velocity[id])
			
			new Float: pOrigin[3]
			new Float: zOrigin[3]
			new Float: zResult[3]
			
			entity_get_vector(id, EV_VEC_origin, pOrigin)
			
			zOrigin[0] = pOrigin[0]
			zOrigin[1] = pOrigin[1]
			zOrigin[2] = pOrigin[2] - 1000
			
			trace_line(id,pOrigin, zOrigin, zResult)
			
			if(entity_get_int(id, EV_INT_sequence) != 8 && (zResult[2] + 100) < pOrigin[2] && is_alive(id) && (Velocity[id][0] > 0.0 && Velocity[id][1] > 0.0 && Velocity[id][2] > 0.0)) 
				entity_set_int(id, EV_INT_sequence, 8)
			
			return PLUGIN_HANDLED
		}
	}
	return PLUGIN_CONTINUE
}
