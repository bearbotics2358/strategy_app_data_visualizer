using Strategy;

namespace Strategy
{
	errordomain FunctionSyntaxError
	{
		ERROR
	}

	class Function : Object
	{
		private string function { get; set construct; }

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
				parse (function);
			}
		}
	}
}

