using Strategy;
using Gee;

namespace Strategy
{
	class Graph : Gtk.DrawingArea, Gtk.Buildable
	{
		public Function function;

		public int margins;

		public float graph_x;
		public float graph_y;

		public bool numbers;
		public bool grid_lines;
		public int grid_min_spacing;

		public Graph (string? func = null)
		{
			this.margins = 50;

			this.width_request = 700;
			this.height_request = 700;
			this.graph_x = 1.0f;
			this.graph_y = 1.0f;

			this.numbers = true;
			this.grid_lines = true;
			this.grid_min_spacing = 30;

			if (func != null)
			{
				function = new Function.with_input (func);
			}

			this.visible = true;

			//print ("%f %f", get_grid_incrament (8.3f), get_grid_incrament (250.1f));
		}

		public override bool draw (Cairo.Context cr)
		{
			print ("redrawn\n");
			int width = get_allocated_width () - (2 * margins);
			int height = get_allocated_height () - (2 * margins);

			//Gtk.StyleContext context = get_style_context ();
			//context.render_background (cr, 0, 0, width, height);

			if (grid_lines)
			{
				float grid_incrament_x = get_grid_incrament (graph_x);
				float grid_incrament_y = get_grid_incrament (graph_y);
				int xinc = (int) ((width * grid_incrament_x) / graph_x);
				int yinc = (int) ((height * grid_incrament_y) / graph_y);

				print ("fincx: %f fincy: %f", grid_incrament_x, grid_incrament_y);
				print ("xinc: %d yinc: %d\n", xinc, yinc);
				for (int x = xinc + margins; x < width + margins; x += xinc)
				{
					cr.move_to (x, margins);
					cr.line_to (x, height + margins);
				}

				for (int y = yinc + margins; y < height + margins; y += yinc)
				{
					cr.move_to (margins, y);
					cr.line_to (width + margins, y);
				}
			
				cr.set_source_rgba (0.9, 0.9, 0.9, 1);
				cr.stroke ();
			}

			HashMap<char, float?> vars = new HashMap<char, float?> ();

			if (function != null)
			{
				for (int x = 0; x < width; x ++)
				{
					vars['x'] = ((graph_x * x) / width);
					int y = (int) (height - ((height * function.eval (vars)) / graph_y));

					if (y < 0)
					{
						continue;
					}

					if (x == 0)
					{
						cr.move_to (x + margins, y + margins);
					}
					else
					{
						cr.line_to (x + margins, y + margins);
					}
					//print ("%f %d\n", ((graph_x * x) / width), y);
				}
			}

			cr.rectangle (margins, margins, width, height);
			cr.set_source_rgba (0, 0, 0, 1);
			cr.stroke ();
			return true;
		}

		public void graph (string func)
		{
			function = new Function.with_input (func);
			queue_draw ();
		}

		private float get_grid_incrament (float in)
		{
			in *= 100;
			for (int i = 100000; i > 0; i /= 10)
			{
				if (in >= i)
				{
					return i / 1000.0f;
				}
			}
			return 0.0001f;
		}
	}
}
