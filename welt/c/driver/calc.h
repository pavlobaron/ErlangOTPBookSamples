#define __WIN32__

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <string.h>
#include <ei.h>
#include <erl_driver.h>

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

static ErlDrvData __start(ErlDrvPort p, char *cmd);
static void __stop(ErlDrvData d);
static void __output(ErlDrvData d, char *o, int size);

static ErlDrvEntry drventry = {
	NULL,
	__start,
	__stop,
	__output,
	NULL,
	NULL,
	"calcdrv",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	ERL_DRV_EXTENDED_MARKER,
	ERL_DRV_EXTENDED_MAJOR_VERSION,
	ERL_DRV_EXTENDED_MAJOR_VERSION,
	ERL_DRV_FLAG_USE_PORT_LOCKING
};

#ifdef __cplusplus
}
#endif