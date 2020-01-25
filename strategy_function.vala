using Strategy;
using Gee;

namespace Strategy
{
	errordomain FuncError
	{
		SYNTAX_ERROR,
		UNDEFINED_VAR
	}

	const uchar PAREN_REF = 0x1f;
	const uchar PAREN_RET = 0x1e;
	const uchar VAR_REF = 0x1d;

	class Function : Object
	{
		public ArrayList<ArrayList<int>> function { get; set; }

		public Function ()
		{
		}

		public Function.with_input (string in)
		{
			set_func (in);
		}

		public void set_func (string in)
		{
			var output = new ArrayList<ArrayList<int>> ();
			var temp_s = new ArrayList<int> ();
			output.add (temp_s);

			int index = 0;
			int index_ret = 0;
			
			for (int i = 0; i < in.length; i ++)
			{
				switch (in[i])
				{
					case '(':
						output[index].add ((int) PAREN_REF);
						output[index].add (output.size);
						output[index].add (index_ret);
						index_ret = index;
						index = output.size;
						temp_s = new ArrayList<int> ();
						output.add (temp_s);
						break;
					case ')':
						output[index].add ((int) PAREN_RET);
						output[index].add (index_ret);
						index = index_ret;
						int temp = output[index].size;
						if (index != 0)
						{
							index_ret = output[index][temp - 1];
							output[index].remove_at (temp - 1);
						}
						break;
					default:
						output[index].add (in[i]);
						break;
				}
			}
			function = output;
		}

		public int eval (HashMap<char, int> in)
		{
			return 0;
		}

		public string to_string ()
		{
			return "";
		}
	}
}

