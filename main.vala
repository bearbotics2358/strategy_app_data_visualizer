int main (string[] argv)
{
	Strategy.Function temp = new Strategy.Function.with_input ("x\\2");
	print ("%s\n", temp.to_string ());
	Gee.HashMap<char, float?> vars = new Gee.HashMap<char, float?> ();
	vars['x'] = 3.0f;
	print ("%f\n", temp.eval (vars));
	Strategy.App application = new Strategy.App ("org.bearbotics.strategy");
	return application.run (argv);
}
