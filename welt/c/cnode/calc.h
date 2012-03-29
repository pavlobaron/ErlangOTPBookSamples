#define __WIN32__

#include <erl_interface.h>

#define MAX 255

#define EXIT -1
#define WRONG_TYPE 0
#define WRONG_PARAM_NUM 1
#define IGNOREIT 2
#define OK 9999

#define RESULT_TAG "result"
#define ERROR_TAG "error"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
	ETERM *from;
	double A;
	double B;
} res_struct;

#define COOKIE "secret"
#define ENODE "erl@pbpc01"

const char *errors[] = {"Wrong type", "Wrong number of arguments"};
const char *fatals[] = {"Cannot initialize connect", "Cannot connect"};

#ifdef __cplusplus
}
#endif