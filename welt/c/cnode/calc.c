#include "calc.h"

static double calc(double A, double B)
{
	return A + B;
}

static int receive(int fd, res_struct *struc)
{
	int _s = 0;
	static char _buf[MAX];
	int _res = 0;
	ErlMessage msg;
	int _ret = OK;
	int i;

	_res = erl_receive_msg(fd, _buf, MAX, &msg);
	switch (_res) {
		case ERL_TICK:
			_ret = IGNOREIT;
		break;

		case ERL_MSG:
			_s = erl_size(msg.msg);
			if (_s < 0) _ret = WRONG_TYPE;
			else if (_s == 2) _ret = EXIT;
			else if (_s != 3) _ret = WRONG_PARAM_NUM;
			else
			{
				(*struc).from = erl_copy_term(erl_element(1, msg.msg));
				(*struc).A = ERL_FLOAT_VALUE(erl_element(2, msg.msg));
				(*struc).B = ERL_FLOAT_VALUE(erl_element(3, msg.msg));
			}

			erl_free_term(msg.from);
			for (i = 1; i <= _s; i++) erl_free_term(erl_element(i, msg.msg));
			erl_free_term(msg.msg);
		break;

		case ERL_ERROR:
			_ret = EXIT;
		break;

		default:
			_ret = EXIT;
		break;
	}

	return _ret;
}

static void post(int fd, ETERM *from, const char *tag, const char *buf)
{
	ETERM *msg;

	msg = erl_format("{~a, ~s}", tag, buf);
	erl_send(fd, from, msg);

	erl_free_term(from);
	erl_free_term(msg);
}

static void result(double res, char *buf)
{
	sprintf(buf, "%.2lf", res);
}

static const char *error(int code)
{
	return errors[code];
}

int main(int argc, char **argv)
{
	res_struct _struct;
	int _res = 0;
	char _buf[100];
	int i;
	int _fd;

	erl_init(NULL, 0);

	for (i = 0; i < 100; i++) _buf[i] = 0;

	if (erl_connect_init(5, COOKIE, 0) == -1) erl_err_quit(fatals[0]);

	_fd = erl_connect(ENODE);
	if (_fd < 0) erl_err_quit(fatals[1]);

	while (1)
	{
		_res = receive(_fd, &_struct);
		switch (_res)
		{
			case EXIT:
			return 0;

			case IGNOREIT:
			continue;

			case WRONG_TYPE:
			case WRONG_PARAM_NUM:
				post(_fd, _struct.from, ERROR_TAG, error(_res));
			break;

			default:
				result(calc(_struct.A, _struct.B), _buf);
  				post(_fd, _struct.from, RESULT_TAG, _buf);
		}
	}

	return 0;
}
