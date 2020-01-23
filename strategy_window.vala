using Strategy;

namespace Strategy
{
	class Window : Gtk.ApplicationWindow
	{
		public Graph graph_area { get; construct; }
		public Window ()
		{
		}

		construct
		{
			init_template ();
			graph_area = (Graph) get_template_child (typeof (Graph), "graph_box");
			//graph_area.draw.connect (draw_callback);
		}

		static construct
		{
			Bytes temp = resources.lookup_data ("/org/bearbotics/strategy/main_window.ui", ResourceLookupFlags.NONE);
			set_template (temp);
			bind_template_child_full ("graph_box", false, 0);
		}

		/*public void graph (string function)
		{
			graph_area.queue_draw ();
		}*/

		/*public bool draw_callback (Cairo.Context cr)
		{
			Gdk.RGBA color;
			Gtk.StyleContext context = get_style_context ();
			int width = get_allocated_width ();	
			int height = get_allocated_height ();
			
			context.render_background (cr, 0, 0, width, height);
			cr.arc (128, 128, 100, 0, Math.PI);
			
			color = context.get_color (context.get_state ());
			cr.set_source_rgba (100, 100, 100, 0.5);
			cr.fill ();
			return false;
		}*/
	}
}
