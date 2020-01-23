using Strategy;

namespace Strategy
{
	class Graph : Gtk.DrawingArea
	{
		public string function { get; set; }

		public Graph ()
		{
		}

		construct
		{
		}

		public override bool draw (Cairo.Context cr)
		{
			stdout.printf ("Redrawn\n");
			//Gdk.RGBA color;
			Gtk.StyleContext context = get_style_context ();
			int width = get_allocated_width ();	
			int height = get_allocated_height ();
			
			context.render_background (cr, 0, 0, width, height);
			//cr.arc_negative (128, -128, 100, 0, Math.PI);
			
			//color = context.get_color (context.get_state ());
			cr.set_source_rgba (0, 0, 0, 1);
			cr.rectangle (0, 0, 300, 300);
			cr.fill ();
			return true;
		}
	}
}
