#define __WIN32__

#include <stdio.h>
#include <string.h>
#include <ei.h>

#define MAX 255

#define EXIT -1
#define WRONG_TYPE 0
#define WRONG_PARAM_NUM 1
#define OK 9999

#define RESULT_TAG "result"
#define ERROR_TAG "error"

#define EOL "\n"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
	double A;
	double B;
} res_struct;

const char *errors[] = {"Wrong type", "Wrong number of arguments"};

#ifdef __cplusplus
}
#endif