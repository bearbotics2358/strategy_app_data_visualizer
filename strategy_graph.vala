using Strategy;
using Gee;

namespace Strategy
{
	class Graph : Gtk.DrawingArea, Gtk.Buildable
	{
		public Function function;

		public float graph_x;
		public float graph_y;

		public Graph (string? func = null)
		{
			this.width_request = 500;
			this.height_request = 500;
			this.graph_x = 1.0f;
			this.graph_y = 1.0f;

			if (func != null)
			{
				function = new Function.with_input (func);
			}

			this.visible = true;
		}

		public override bool draw (Cairo.Context cr)
		{
			print ("redrawn\n");
			int width = get_allocated_width ();	
			int height = get_allocated_height ();

			Gtk.StyleContext context = get_style_context ();
			context.render_background (cr, 0, 0, width, height);

			HashMap<char, float?> vars = new HashMap<char, float?> ();

			if (function != null)
			{
				for (int x = 0; x < width; x ++)
				{
					vars['x'] = ((graph_x * x) / width);
					int y = (int) (height - ((height *function.eval (vars)) / graph_y));

					if (x == 0)
					{
						cr.move_to (x, y);
					}
					else
					{
						cr.line_to (x, y);
					}
					//print ("%f %d\n", ((graph_x * x) / width), y);
				}
			}
			
			cr.set_source_rgba (1, 0, 0, 1);
			cr.stroke ();
			return true;
		}

		public void graph (string func)
		{
			function = new Function.with_input (func);
			queue_draw ();
		}
	}
}
