#include "calc.h"

static double calc(double A, double B)
{
	return A + B;
}

static int receive(res_struct *struc, char *in)
{
	int _v = 0, _i = 0, _s = 0, _t = 0, _a = 0;
	ei_term _term;
	const char *_buf = in;

	ei_decode_version(_buf, &_i, &_v);
	ei_get_type(_buf, &_i, &_t, &_s);
	if (_t != ERL_SMALL_TUPLE_EXT) return WRONG_TYPE;

	ei_decode_tuple_header(_buf, &_i, &_a);
	if (_a == 1) return EXIT;
	else if (_a != 2) return WRONG_PARAM_NUM;

	ei_decode_ei_term(_buf, &_i, &_term);
	(*struc).A = _term.value.d_val;
	ei_decode_ei_term(_buf, &_i, &_term);
	(*struc).B = _term.value.d_val;

	return OK;
}

static void post(const char *tag, const char *buf, ErlDrvPort p, char *o)
{
	ei_x_buff _ei;

	ei_x_new_with_version(&_ei);
	ei_x_encode_tuple_header(&_ei, 2);
	ei_x_encode_atom(&_ei, tag);
	ei_x_encode_string_len(&_ei, buf, strlen(buf));

	driver_output(p, _ei.buff, _ei.buffsz);

	ei_x_free(&_ei);
}

static void result(double res, char *buf)
{
	sprintf(buf, "%.2lf", res);
}

static const char *error(int code)
{
	return errors[code];
}

DRIVER_INIT(calcdrv)
{
	return &drventry;
}

static ErlDrvData __start(ErlDrvPort p, char *cmd)
{
	return (ErlDrvData)memcpy((ErlDrvPort*)driver_alloc(sizeof(ErlDrvPort)),
								&p,
								sizeof(ErlDrvPort));
}

static void __stop(ErlDrvData d)
{
	driver_free((char*)d);
}

static void __output(ErlDrvData d, char *o, int size)
{
	res_struct _struct;
	int _res = 0;
	int _ret = 0;
	char _buf[100];
	int i;
	for (i = 0; i < 100; i++) _buf[i] = 0;

	_res = receive(&_struct, o);
	switch (_res)
	{
		case EXIT:
		break;

		case WRONG_TYPE:
		case WRONG_PARAM_NUM:
			post(ERROR_TAG, error(_res), *((ErlDrvPort*)d), o);
		break;

		default:
			result(calc(_struct.A, _struct.B), _buf);
  			post(RESULT_TAG, _buf, *((ErlDrvPort*)d), o);
	}
}
