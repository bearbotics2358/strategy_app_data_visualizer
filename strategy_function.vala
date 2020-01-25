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
	const int ADD = '+';
	const int SUB = '-';
	const int MULT = '*';
	const int DIVIDE = '/';
	const int EXPONENT = '^';
	const int LOG = 0x7f;

	class Function : Object
	{
		private ArrayList<ArrayList<int>> function { get; set; }

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
						if (is_digit (in[i]) == 1)
						{
							string temp_s = "";

							while (is_digit (in[i]) == 1 || is_digit (in[i]) == 2)
							{
								temp_s += in[i].to_string ();
								i ++;
							}

							i --;
							float temp_f = float.parse (temp_s);
							output[index].add (CONST);
							output[index].add (*((int *)((void *)(&temp_f))));
						}
						else if (in[i].isalpha ())
						{
							output[index].add (VAR_REF);
							output[index].add (in[i]);
						}
						else
						{
							output[index].add (in[i]);
						}
						break;
				}
			}
			output[0].add (0);
			function = output;
		}

		public int eval (HashMap<char, float?> in)
		{
			var output = new LinkedList<LinkedList<int>> ();
			for (int i = 0; i < function.size; i ++)
			{
				output.add (new LinkedList<int> ());
				function[i].foreach ((g) => { output[i].add (g); return true; });
			}

			int index = 0;
			int i = 0;

			while (function[index][i] != 0)
			{
				
			}
			return 0;
		}

		private void eval_manage (LinkedList<LinkedList<int>> *in, int index, HashMap<char, float?> vars)
		{
			sub_eval (in, index, vars, @"$(EXPONENT)$(LOG)");
			sub_eval (in, index, vars, @"$(MULT)$(DIVIDE)");
			sub_eval (in, index, vars, @"$(ADD)$(SUB)");
		}

		private void sub_eval (LinkedList<LinkedList<int>> *in, int index, HashMap<char, float?> vars, string ops) throws FuncError
		{
			LinkedList<int> output = in->get (index);

			for (int i = 0; i < output.size; i ++)
			{
				for (int j = 0; j < ops.length; j ++)
				{
					if (output[i] == ops[j])
					{
						float[] args = new float[2];

						if (output[i - 2] == CONST)
						{
							int temp_i1 = output[i - 1];
							args[0] = *((float *)(&temp_i1));
						}
						else if (output[i - 2] == VAR_REF)
						{
							args[0] = vars[(char) output[i - 1]];
						}
						else
						{
							throw new FuncError.SYNTAX_ERROR ("");
						}

						switch ((int) ops[j])
						{
							case ADD:
							case SUB:
							case MULT:
							case DIVIDE:
							case EXPONENT:
							case LOG:
								if (output[i + 1] == CONST)
								{
									int temp_i1 = output[i + 2];
									args[1] = *((float *)(&temp_i1));
								}
								else if (output[i + 1] == VAR_REF)
								{
									args[1] = vars[(char) output[i + 2]];
								}
								else
								{
									throw new FuncError.SYNTAX_ERROR ("");
								}
								break;
							default:
								args[1] = 0;
								break;
						}
					}
				}
			}
		}

		private float eval_op (char op, int[] args)
		{
			return 0.0f;
		}

		private char is_digit (char in)
		{
			switch (in)
			{
				case '0':
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
				case '8':
				case '9':
					return 1;
				case '.':
					return 2;
				default:
					return 0;
			}
		}

		public string to_string ()
		{
			return "";
		}
	}
}

