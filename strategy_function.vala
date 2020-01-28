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
	const int LOG = '\\';

	float logbasef (float b, float in)
	{
		return Math.log10f (in) / Math.log10f (b);
	}

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
						//output[index].add (PAREN_RET);
						//output[index].add (index_ret);
						index = index_ret;
						int temp = output[index].size;
						if (index != 0)
						{
							index_ret = output[index][temp - 1];
						}
						output[index].remove_at (temp - 1);
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
							output[index].add (*((int *)(&temp_f)));
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
			function = output;
		}

		public float eval (HashMap<char, float?> in)
		{
			var output = new LinkedList<LinkedList<int>> ();
			for (int i = 0; i < function.size; i ++)
			{
				output.add (new LinkedList<int> ());
				function[i].foreach ((g) => { output[i].add (g); return true; });
			}
			
			float out = eval_manage (output, 0, in);
			//delete output;
			return out;
		}


		private float eval_manage (LinkedList<LinkedList<int>> *in, int index, HashMap<char, float?> vars)
		{
			//in->get (index).foreach ((a) => { print ("Index: %d, Num: %d\n", index, a); return true; });
			int[] in_1 = {EXPONENT, LOG};
			sub_eval (in, index, vars, in_1);
			int[] in_2 = {MULT, DIVIDE};
			sub_eval (in, index, vars, in_2);
			int[] in_3 = {ADD, SUB};
			sub_eval (in, index, vars, in_3);
			int temp_i = in->get (index).get (1);
			return *((float *)(&temp_i));
		}

		private void sub_eval (LinkedList<LinkedList<int>> *in, int index, HashMap<char, float?> vars, int[] ops) throws FuncError
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
							if (vars.has_key ((char) output[i - 1]))
							{
								args[0] = vars[(char) output[i - 1]];
							}
							else
							{
								throw new FuncError.UNDEFINED_VAR (@"Var $(output[i - 1]) is Undefined");
							}
						}
						else if (output[i - 2] == PAREN_REF)
						{
							args[0] = eval_manage (in, output[i - 1], vars);
						}
						else
						{
							throw new FuncError.SYNTAX_ERROR (@"Could Not Find First Argument for $(ops[j]) at Block $(index), Index $(i)");
						}

						switch (ops[j])
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
									if (vars.has_key ((char) output[i + 2]))
									{
										args[1] = vars[(char) output[i + 2]];
									}
									else
									{
										throw new FuncError.UNDEFINED_VAR (@"Var $(output[i + 2]) is Undefined");
									}
								}
								else if (output[i + 1] == PAREN_REF)
								{
									args[1] = eval_manage (in, output[i + 2], vars);
								}
								else
								{
									throw new FuncError.SYNTAX_ERROR (@"Could Not Find Second Argument for $(ops[j]) at Block $(index), Index $(i)");
								}
								break;
							default:
								args[1] = 0;
								break;
						}
						float temp_f = eval_op (ops[j], args);
						int result = *((int *)(&temp_f));
						i -= 2;
						output.remove_at (i);
						output.remove_at (i);
						output.remove_at (i);
						output.remove_at (i);
						output[i] = result;
						output.insert (i, CONST);
						i ++;
					}
				}
			}
		}

		private float eval_op (int op, float[] args)
		{
			switch (op)
			{
				case ADD:
					return args[0] + args[1];
				case SUB:
					return args[0] - args[1];
				case MULT:
					return args[0] * args[1];
				case DIVIDE:
					return args[0] / args[1];
				case EXPONENT:
					return Math.powf (args[0], args[1]);
				case LOG:
					return logbasef (args[0], args[1]);
			}
			return float.NAN;
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
			string out = "";
			bool flag = false;
			for (int i = 0; i < function.size; i ++)
			{
				for (int j = 0; j < function[i].size; j ++)
				{
					if (flag)
					{
						int temp_i = function[i][j];
						out += (*((float *)(&temp_i))).to_string () + " ";
						flag = false;
					}
					else
					{
						out += ((char) function[i][j]).to_string () + " ";
						if (function[i][j] == CONST)
						{
							flag = true;
						}
					}
				}
				out += "\n";
			}
			return out;
		}
	}
}

