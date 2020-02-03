using Strategy;

namespace Strategy
{
	class App : Gtk.Application
	{
		public App (string application_id)
		{
			Object (application_id: application_id);
		}

		construct
		{
			activate.connect ((object) => { entry (null, null); });
			open.connect ((object, files, hint) => { entry (files, hint); });
		}

		void entry (File[]? files = null, string? hint = null)
		{
			Window window = new Window ();
			window.set_application (this);
			window.present ();
		}
	}
}
