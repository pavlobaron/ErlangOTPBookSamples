#include "calc.h"

static double _calc(double A, double B)
{
	return A + B;
}

static int receive(res_struct *struc, ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
	long _l;

	if (argc != 2) return WRONG_PARAM_NUM;
	if (!enif_get_double(env, argv[0], &struc->A))
	{
		if (!enif_get_long(env, argv[0], &_l)) return WRONG_TYPE;
		else struc->A = _l;
	}

	if (!enif_get_double(env, argv[1], &struc->B))
	{
		if (!enif_get_long(env, argv[1], &_l)) return WRONG_TYPE;
		else struc->B = _l;
	}

	return OK;
}

static ERL_NIF_TERM post(const char *tag, const char *buf, ErlNifEnv* env)
{
	return enif_make_tuple(env, 2,
						   enif_make_atom(env, tag),
						   enif_make_string(env, buf, ERL_NIF_LATIN1));
}

static void result(double res, char *buf)
{
	sprintf(buf, "%.2lf", res);
}

static const char *error(int code)
{
	return errors[code];
}

static ErlNifFunc __funcs[] =
{
	{"calc", 2, calc}
};

ERL_NIF_INIT(nifcalc, __funcs, NULL, NULL, NULL, NULL)

static ERL_NIF_TERM calc(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
	res_struct _struct;
	char _buf[100];
	int i;
	int _res = 0;
	
	for (i = 0; i < 100; i++) _buf[i] = 0;
	_res = receive(&_struct, env, argc, argv);
	switch (_res)
	{
		case WRONG_TYPE:
		case WRONG_PARAM_NUM:
			return post(ERROR_TAG, error(_res), env);
		break;

		default:
			result(_calc(_struct.A, _struct.B), _buf);
  			return post(RESULT_TAG, _buf, env);
	}
}
