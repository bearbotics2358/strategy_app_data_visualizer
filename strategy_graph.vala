using Strategy;
using Gee;

namespace Strategy
{
	class Graph : Gtk.DrawingArea
	{
		public Function function { get; set; }

		public Graph ()
		{
		}

		construct
		{
		}

		public override bool draw (Cairo.Context cr)
		{
			stdout.printf ("Redrawn\n");
			Gtk.StyleContext context = get_style_context ();
			HashMap<char, float?> vars = new HashMap<char, float?> ();

			int width = get_allocated_width ();	
			int height = get_allocated_height ();

			function = new Function.with_input ("2\\x");
			print (function.to_string ());
			if (function != null)
			{
				for (int x = 0; x < width; x ++)
				{
					vars['x'] = ((float) x) / 10;
					int y = (int) function.eval (vars);
					cr.rectangle (x, height - y, 1, 1);
				}
			}
			context.render_background (cr, 0, 0, width, height);
			//cr.arc_negative (128, -128, 100, 0, Math.PI);
			
			//color = context.get_color (context.get_state ());
			cr.set_source_rgba (1, 0, 0, 1);
			//cr.rectangle (0, 0, 300, 300);
			cr.fill ();
			return true;
		}

		public void graph (string func)
		{
			function = new Function.with_input (func);
			queue_draw ();
		}
	}
}
