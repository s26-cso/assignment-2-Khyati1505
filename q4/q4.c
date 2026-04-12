#include <stdio.h>
#include <dlfcn.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char op[6];
    int num1, num2;
    void* handle=NULL;
    char last_op[6]="";

    while (scanf("%s %d %d", op, &num1, &num2)==3) {
        if (strcmp(op, last_op)!=0) {
            if (handle) dlclose(handle);
            char libname[16];
            snprintf(libname, sizeof(libname), "./lib%s.so", op);
            handle = dlopen(libname, RTLD_LAZY);
        }

        typedef int (*op_func)(int, int);
        op_func func=(op_func)dlsym(handle, op);
        printf("%d\n",func(num1, num2));
        strcpy(last_op,op);
    }
    
    if (handle) dlclose(handle);
    return 0;
}