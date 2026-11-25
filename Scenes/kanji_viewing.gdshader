shader_type canvas_item;

float when_above_0(float x)
{
	return -1.0 * sign(0.0 - x);
}

float when_below_1(float x)
{
	return sign(2.0 - (x*2.0));
}

void fragment() {
	COLOR.xyz = vec3(1,1,1) * when_below_1(COLOR.x);
	//COLOR.xyz = 1.0 - COLOR.xyz;
}
