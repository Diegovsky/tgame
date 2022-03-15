#pragma once

#include <stddef.h>

typedef enum {
    OSUTILS_OPENFILE_FLAG_IMAGE,
    OSUTILS_OPENFILE_FLAG_NONE,
} OSUtilsOpenfileFlag;

typedef struct {
    const char name[32];
    const char exts[4][16];
} OSUtilsOpenfileFilter;

const char* openfile_dialog(const char* path, const OSUtilsOpenfileFilter* filter);
