#define __WIN32__

#ifdef __cplusplus
extern "C" {
#endif

#include <string.h>
#include <erl_nif.h>

#define MAX 255

#define EXIT -1
#define WRONG_TYPE 0
#define WRONG_PARAM_NUM 1
#define OK 9999

#define RESULT_TAG "result"
#define ERROR_TAG "error"

typedef struct
{
	double A;
	double B;
} res_struct;

const char *errors[] = {"Wrong type", "Wrong number of arguments"};

static ERL_NIF_TERM calc(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]);

#ifdef __cplusplus
}
#endif