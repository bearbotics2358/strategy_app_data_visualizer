using Strategy;
using Gee;

namespace Strategy
{
	errordomain FunctionSyntaxError
	{
		ERROR
	}

	class Function : Object
	{
		private string function_s { get; set construct; }
		private ArrayList<StringBuilder> function { get; set; }

		public Function ()
		{
		}

		public Function.with_input (string in)
		{
			Object (function: in);
		}

		construct
		{
			if (function != null)
			{
				parse_string (function_s);
			}
		}

		public void parse_string (string in)
		{
			function = new ArrayList<StringBuilder> ();
			function.add (new StringBuilder ());
			int paren_index = 0;
			
			for (int i = 0; i < in.length; i ++)
			{
				switch (in[i])
				{
				}
			}
		}
	}
}

