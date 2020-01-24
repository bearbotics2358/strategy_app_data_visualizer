int main (string[] argv)
{
	Strategy.Function temp = new Strategy.Function.with_input ("x+(x-3*(y+2))-8");
	Strategy.App application = new Strategy.App ("org.bearbotics.strategy");
	return application.run (argv);
}
