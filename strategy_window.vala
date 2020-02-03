using Strategy;
using Gee;

namespace Strategy
{
	class Window : Gtk.ApplicationWindow
	{
		private Graph graph_area;

		public Window ()
		{
			graph_area = new Graph ("5*x^2");
			this.add (graph_area);
		}

		/*public void graph (string function)
		{
			graph_area.queue_draw ();
		}*/

		/*public bool draw_callback (Cairo.Context cr)
		{
			stdout.printf ("Redrawn\n");
			Gtk.StyleContext context = graph_area.get_style_context ();
			HashMap<char, float?> vars = new HashMap<char, float?> ();

			int width = graph_area.get_allocated_width ();	
			int height = graph_area.get_allocated_height ();

			function = new Function.with_input ("x^2");
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
		}*/
	}
}
