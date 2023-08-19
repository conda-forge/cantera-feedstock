#include "Python.h"

int main(int argc, char** argv)
{
    Py_Initialize();
    PyRun_SimpleString(
        "import sys\n"
        "print('Hello, world')\n"
        "print('embedded sys.path:', sys.path)\n"
        "sys.stdout.flush()\n");
    return 0;
}
