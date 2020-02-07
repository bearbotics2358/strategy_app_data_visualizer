using Strategy;
using Gee;

namespace Strategy
{
	enum GraphScaleMode
	{
		NO_SCALE,
		FIXED_LEFT,
		FIXED_MIDDLE,
		FIXED_RIGHT
	}
		
	class Graph : Gtk.DrawingArea
	{
		public Function function;

		public int margins;

		public float graph_x;
		public float graph_y;
		public float graph_sx;
		public float graph_sy;

		public GraphScaleMode scale_mode;
		public int graph_scale; // What inner graph pixel length or width should be when graph length or width is 1

		public bool grid_lines;
		public int grid_min_spacing;

		public bool numbers;
		public int num_space;
		public uchar font_size;

		private int width;
		private int height;

		public Graph (string? func = null)
		{
			this.margins = 50;

			this.width_request = 700;
			this.height_request = 700;

			this.graph_x = 1.0f;
			this.graph_y = 1.0f;
			this.graph_sx = -0.5f;
			this.graph_sy = -0.2f;

			this.scale_mode = GraphScaleMode.FIXED_RIGHT;
			this.graph_scale = 600;

			this.grid_lines = true;
			this.grid_min_spacing = 30;

			this.numbers = true;
			this.num_space = 30;
			this.font_size = 12;

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

			//Gtk.StyleContext context = get_style_context ();
			//context.render_background (cr, 0, 0, width, height);

			if (grid_lines || numbers)
			{
				cr.set_font_size ((float) font_size);

				float grid_incrament_x = get_grid_incrament (graph_x);
				float grid_incrament_y = get_grid_incrament (graph_y);
				int xinc = (int) ((width * grid_incrament_x) / graph_x);
				int yinc = (int) ((height * grid_incrament_y) / graph_y);
				float fx = graph_sx + grid_incrament_x;
				float fy = (grid_incrament_y * ((height / yinc) - 1)) + graph_sy;

				print ("fincx: %f fincy: %f", grid_incrament_x, grid_incrament_y);
				print ("xinc: %d yinc: %d\n", xinc, yinc);
				if (!(xinc <= 0 || yinc <= 0))
				{
					for (int x = xinc + margins; x < width + margins; x += xinc)
					{
						if (grid_lines)
						{
							cr.move_to (x, margins);
							cr.line_to (x, height + margins);
						}
						if (numbers)
						{
							cr.move_to (x, height + margins + num_space);
							cr.show_text (round_to (fx, grid_incrament_x).to_string ());
							fx += grid_incrament_x;
						}
					}

					for (int y = yinc + margins; y < height + margins; y += yinc)
					{
						if (grid_lines)
						{
							cr.move_to (margins, y);
							cr.line_to (width + margins, y);
						}
						if (numbers)
						{
							cr.move_to (margins - num_space, y);
							cr.show_text (round_to (fy, grid_incrament_y).to_string ());
							fy -= grid_incrament_y;
						}
					}
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

		public override bool configure_event (Gdk.EventConfigure event)
		{
			//print ("event\n");

			if (event.type == Gdk.EventType.CONFIGURE)
			{
				print ("resized\n");

				this.width = event.width - (2 * margins);
				this.height = event.height - (2 * margins);

				switch (scale_mode)
				{
					case GraphScaleMode.FIXED_LEFT:
						this.graph_x = (float) width / graph_scale;
						this.graph_y = (float) height / graph_scale;
						break;
					case GraphScaleMode.FIXED_MIDDLE:
						float temp_x = (float) width / graph_scale - graph_x;
						float temp_y = (float) height / graph_scale - graph_y;
						this.graph_x += temp_x;
						this.graph_y += temp_y;
						this.graph_sx -= temp_x / 2;
						this.graph_sy -= temp_y / 2;
						break;
					case GraphScaleMode.FIXED_RIGHT:
						float temp_x = (float) width / graph_scale - graph_x;
						float temp_y = (float) height / graph_scale - graph_y;
						this.graph_x += temp_x;
						this.graph_y += temp_y;
						this.graph_sx -= temp_x;
						this.graph_sy -= temp_y;
						break;
				}
			}

			print ("graph_x: %f graph_y: %f\n", graph_x, graph_y);
			return false;
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

		private float round_to (float in, float round_place)
		{
			string temp_s = round_place.to_string ();
			bool flag_1 = false;
			bool flag_d = false;
			int decimals = 0;

			for (int i = 0; i < temp_s.length; i ++)
			{
				if (flag_d)
				{
					decimals ++;
					if (flag_1)
					{
						break;
					}
				}

				if (flag_1)
				{
					if (flag_d)
					{
						break;
					}
					decimals --;
				}

				if (!flag_1)
				{
					flag_1 = temp_s[i] == '1';
				}

				if (!flag_d)
				{
					flag_d = temp_s[i] == '.';
				}
			}

			if (!flag_1 && !flag_d)
			{
				return float.INFINITY;
			}

			// Decimal places to round
			// -3 -2 -1 0 . 1 2 3 4
			long temp = (long) ((in * Posix.pow (10, decimals)) + (in > 0 ? 0.5 : -0.5));
			return (float) (temp / Posix.pow (10, decimals));
		}
	}
}

