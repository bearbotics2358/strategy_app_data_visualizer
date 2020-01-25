using Strategy;
using Gee;

namespace Strategy
{
	errordomain FuncError
	{
		SYNTAX_ERROR,
		UNDEFINED_VAR
	}

	const int PAREN_REF = 0x1f;
	const int PAREN_RET = 0x1e;
	const int VAR_REF = 0x1d;
	const int CONST = 0x1c;

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
			output.add (new ArrayList<int> ());

			int index = 0;
			int index_ret = 0;
			
			for (int i = 0; i < in.length; i ++)
			{
				switch (in[i])
				{
					case '(':
						output[index].add (PAREN_REF);
						output[index].add (output.size);
						output[index].add (index_ret);
						index_ret = index;
						index = output.size;
						output.add (new ArrayList<int> ());
						break;
					case ')':
						output[index].add (PAREN_RET);
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
			output[0].add (0);
			function = output;
		}

		public int eval (HashMap<int, int> in)
		{
			var output = new LinkedList<LinkedList<int>> ();
			for (int i = 0; i < function.size; i ++)
			{
				output.add (new LinkedList<int> ());
				function[i].foreach ((g) => { output[i].add (g); return true; });
			}

			int i = 0;
			int j = 0;

			while (function[i][j] != 0)
			{
				
			}
			return 0;
		}

		public string to_string ()
		{
			return "";
		}

		private bool is_digit (char in)
		{
			switch (in)
			{
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
					return true;
				default:
					return false;
			}
		}
	}
}

