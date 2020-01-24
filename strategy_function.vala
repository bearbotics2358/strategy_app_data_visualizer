using Strategy;
using Gee;

namespace Strategy
{
	errordomain Function
	{
		SYNTAX_ERROR
	}

	const uchar PAREN_REF = 0x1f;
	const uchar PAREN_RET = 0x1e;
	const uchar VAR_REF = 0x1d;

	class Function : Object
	{
		private string function_s { get; set construct; }
		private ArrayList<string> function { get; set; }

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
				set_function (function_s);
			}
		}

		public void set_function (string in)
		{
			ArrayList<StringBuilder> output = new ArrayList<StringBuilder> ();
			output.add (new StringBuilder ());

			int index = 0;
			int index_ret = 0;
			
			for (int i = 0; i < in.length; i ++)
			{
				switch (in[i])
				{
					case '(':
						output[index].append ("" + PAREN_REF + output.size + index_ret);
						index_ret = index;
						index = output.size;
						output.add (new StringBuilder ());
						break;
					case ')':
						output[index].append ("" + PAREN_RET + index_ret);
						index = index_ret;
						ssize_t temp = output[index].len;
						index_ret = (int) output[index].str[temp - 1];
						output[index].truncate (1);
						break;
				}
			}

			function = new ArrayList<string> ();
			for (int i = 0; i < output.size; i ++)
			{
				function.add (output[i].str); 
			}
		}
	}
}

