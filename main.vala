int main (string[] argv)
{
	string in = "x+(x-3*(y+2)-2)-8";
	print (in + "\n");
	Strategy.Function temp = new Strategy.Function.with_input (in);
	Gee.HashMap<char, float?> vars = new Gee.HashMap<char, float?> ();
	vars['x'] = 3;
	vars['y'] = 2.5f;
	print ("%s\n", temp.to_string ());
	print ("%f\n", temp.eval (vars));
	Strategy.App application = new Strategy.App ("org.bearbotics.strategy");
	return application.run (argv);
}
