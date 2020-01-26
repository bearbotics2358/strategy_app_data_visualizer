int main (string[] argv)
{
	Strategy.Function temp = new Strategy.Function.with_input ("x+(x-3*(y+2)-2)-8");
	Gee.HashMap<char, float?> vars = new Gee.HashMap<char, float?> ();
	vars['x'] = 3;
	vars['y'] = 2.5f;
	print ("%f\b", temp.eval (vars));
	Strategy.App application = new Strategy.App ("org.bearbotics.strategy");
	return application.run (argv);
}
