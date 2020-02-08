using Strategy;
using Gee;

namespace Strategy
{
	enum GraphScaleMode
	{
		NO_SCALE,
		FIXED_START,
		FIXED_MIDDLE,
		FIXED_END
	}

	enum RoundMode
	{
		TO_ZERO,
		AWAY_ZERO,
		TO_INFINITY,
		AWAY_INFINITY,
		NORMAL
	}

	class Graph : Gtk.DrawingArea
	{
		// Function to graph
		public Function function;

		// Margin width around graph in pixels
		public int margins;

		// Type of scaling for x and y
		public GraphScaleMode scale_mode_x;
		public GraphScaleMode scale_mode_y;
		// What inner graph pixel length or width should be when graph length or width is 1
		public int scale_x;
		public int scale_y;

		// To draw grid lines or not
		public bool grid_lines;
		// Spacing between grid linues, unused
		public int grid_min_spacing;

		// To draw grid line numbers or not
		public bool numbers;
		// Space between graph boundary and number in pixels
		public int num_space;
		// Font size
		public uchar font_size;

		private int width;
		private int height;

		private float graph_x;
		private float graph_y;
		private float graph_sx;
		private float graph_sy;

		public Graph (string? func = null)
		{
			this.margins = 50;

			this.scale_mode_x = GraphScaleMode.FIXED_MIDDLE;
			this.scale_mode_y = GraphScaleMode.FIXED_MIDDLE;

			set_sx_x (-0.5f, 1.0f, 700);
			set_sy_y (-0.5f, 1.0f, 700);

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
				float fx = graph_sx;
				float fy = (grid_incrament_y * ((height / yinc)));
				print ("fy: %f graph_sy: %f\n", fy, graph_sy);
				int x = (int) ((((round_to (graph_sx, grid_incrament_x, RoundMode.TO_INFINITY) - graph_sx) * width) / graph_x) + margins);
				int y = (int) ((((round_to (graph_sy, grid_incrament_y, RoundMode.TO_INFINITY) - graph_sy) * height) / graph_y) + margins);

				print ("fincx: %f fincy: %f", grid_incrament_x, grid_incrament_y);
				print ("xinc: %d yinc: %d\n", xinc, yinc);
				if (!(xinc <= 0 || yinc <= 0))
				{
					for (; x < width + margins; x += xinc)
					{
						if (grid_lines)
						{
							cr.move_to (x, margins);
							cr.line_to (x, height + margins);
						}
						if (numbers)
						{
							cr.move_to (x, height + margins + num_space);
							cr.show_text (round_to (fx, grid_incrament_x, RoundMode.TO_INFINITY).to_string ());
							fx += grid_incrament_x;
						}
					}

					for (; y < height + margins; y += yinc)
					{
						if (grid_lines)
						{
							cr.move_to (margins, y);
							cr.line_to (width + margins, y);
						}
						if (numbers)
						{
							cr.move_to (margins - num_space, y);
							cr.show_text (round_to (fy, grid_incrament_y, RoundMode.AWAY_INFINITY).to_string ());
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

				switch (scale_mode_x)
				{
					case GraphScaleMode.FIXED_START:
						this.graph_x = (float) width / scale_x;
						break;
					case GraphScaleMode.FIXED_MIDDLE:
						float diff_x = (float) width / scale_x - graph_x;
						this.graph_x += diff_x;
						this.graph_sx -= diff_x / 2;
						break;
					case GraphScaleMode.FIXED_END:
						float diff_x = (float) width / scale_x - graph_x;
						this.graph_x += diff_x;
						this.graph_sx -= diff_x;
						break;
				}

				switch (scale_mode_y)
				{
					case GraphScaleMode.FIXED_START:
						this.graph_y = (float) height / scale_y;
						break;
					case GraphScaleMode.FIXED_MIDDLE:
						float diff_y = (float) height / scale_y - graph_y;
						this.graph_y += diff_y;
						this.graph_sy -= diff_y / 2;
						break;
					case GraphScaleMode.FIXED_END:
						float diff_y = (float) height / scale_y - graph_y;
						this.graph_y += diff_y;
						this.graph_sy -= diff_y;
						break;
				}

			}

			print ("graph_x: %f graph_y: %f\n", graph_x, graph_y);
			return false;
		}

		// Graph function
		public void graph (string func)
		{
			function = new Function.with_input (func);
			queue_draw ();
		}

		// Sets graph starting x position and x range
		public void set_sx_x (float sx, float x, int n_width)
		{
			this.graph_sx = sx;
			this.graph_x = x;
			this.scale_x = (int) (n_width / x);
			this.width_request = n_width + (2 * margins);
		}

		// Sets graph starting y position and y range
		public void set_sy_y (float sy, float y, int n_height)
		{
			this.graph_sy = sy;
			this.graph_y = y;
			this.scale_y = (int) (n_height / y);
			this.height_request = n_height + (2 * margins);
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

		private float round_to (float in, float round_place, RoundMode rounding)
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

			float rounder = 0.0f;

			switch (rounding)
			{
				case RoundMode.TO_INFINITY:
					rounder = in > 0 ? 1.0f : 0.0f;
					break;
				case RoundMode.AWAY_INFINITY:
					rounder = in > 0 ? 0.0f : -1.0f;
					break;
				case RoundMode.TO_ZERO:
					rounder = in > 0 ? 0.0f : 1.0f;
					break;
				case RoundMode.AWAY_ZERO:
					rounder = in > 0 ? 1.0f : 0.0f;
					break;
				case RoundMode.NORMAL:
					rounder = in > 0 ? 0.5f : -0.5f;
					break;
			}

			// Decimal places to round
			// -3 -2 -1 0 . 1 2 3 4
			long temp = (long) ((in * Posix.pow (10, decimals)) + rounder);
			return (float) (temp / Posix.pow (10, decimals));
		}
	}
}


