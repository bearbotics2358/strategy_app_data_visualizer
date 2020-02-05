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
		public float graph_sx;
		public float graph_sy;

		public bool grid_lines;
		public int grid_min_spacing;
		public int num_space;

		public Graph (string? func = null)
		{
			this.margins = 50;

			this.width_request = 700;
			this.height_request = 700;
			this.graph_x = 1.0f;
			this.graph_y = 1.0f;
			this.graph_sx = -0.5f;
			this.graph_sy = -0.2f;

			this.grid_lines = true;
			this.grid_min_spacing = 30;
			this.num_space = 20;

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
				cr.set_font_size (12.0f);
				float grid_incrament_x = get_grid_incrament (graph_x);
				float grid_incrament_y = get_grid_incrament (graph_y);
				int xinc = (int) ((width * grid_incrament_x) / graph_x);
				int yinc = (int) ((height * grid_incrament_y) / graph_y);
				float fx = graph_sx;
				float fy = (grid_incrament_y * ((height / yinc) - 1)) + graph_sy;

				print ("fincx: %f fincy: %f", grid_incrament_x, grid_incrament_y);
				print ("xinc: %d yinc: %d\n", xinc, yinc);
				for (int x = xinc + margins; x < width + margins; x += xinc)
				{
					cr.move_to (x, margins);
					cr.line_to (x, height + margins);
					cr.move_to (x, height + margins + num_space);
					cr.show_text (fx.to_string ());
					fx += grid_incrament_x;
				}

				for (int y = yinc + margins; y < height + margins; y += yinc)
				{
					cr.move_to (margins, y);
					cr.line_to (width + margins, y);
					cr.move_to (margins - num_space, y);
					cr.show_text (fy.to_string ());
					fy -= grid_incrament_y;
				}
			
				cr.set_source_rgba (0.9, 0.9, 0.9, 1);
				cr.stroke ();
			}

			HashMap<char, float?> vars = new HashMap<char, float?> ();

			if (function != null)
			{
				bool flag = true;
				for (int x = 0; x < width; x ++)
				{
					vars['x'] = ((graph_x * x) / width) + graph_sx;
					int y = (int) (height - (height * (function.eval (vars) - graph_sy) / graph_y));

					if (y < 0 || y > height)
					{
						flag = true;
						continue;
					}

					if (flag)
					{
						cr.move_to (x + margins, y + margins);
						flag = false;
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
