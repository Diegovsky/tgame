#include <lua.h>
#include <lauxlib.h>
#include <stddef.h>
#include <string.h>

#include "osutils.h"
#include "subprojects/lua-5.4.3/src/lua.h"

typedef lua_State* lua;


const OSUtilsOpenfileFilter* _outil_string_to_filter(const char* filtername);


static OSUtilsOpenfileFilter const OS_UTILS_OPEN_FILE_FILTER_IMAGE = {
    "Images",
    {
        "*.png",
        "*.ico",
        "*.jpeg",
        "*.jpg",
    }
};

int openfile_dialog_l(lua L)
{
    const char* path;
    const char* filtername;
    const OSUtilsOpenfileFilter* filter;
    if(!(path = luaL_checkstring(L, 1))) 
    {
        return luaL_error(L, "Expecting first parameter to be typeof: string");
    }
    if(!(filtername = luaL_checkstring(L, 2))) 
    {
        return luaL_error(L, "Expecting second parameter to be typeof: string");
    }
    if(strlen(path) == 0)
    {
        path = ".";
    }
    if(!(filter = _outil_string_to_filter(filtername)))
    {
        return luaL_error(L, "Invalid filter type of '%s'.", filtername);
    }

    const char* existentpath = openfile_dialog(path, filter);
    if(existentpath == NULL) {
        lua_pushnil(L);
    } else {
        lua_pushstring(L, existentpath);
    }
    return 1;
}

const OSUtilsOpenfileFilter* _outil_string_to_filter(const char* filtername)
{
    if(strstr(filtername, "image"))
    {
        return &OS_UTILS_OPEN_FILE_FILTER_IMAGE;
    }
    return NULL;
}

static void _outil_register(lua L, const luaL_Reg* members_list, size_t members) {
    int start = lua_gettop(L);

    lua_newtable(L);
    for(size_t i = 0; i < members; i++) {
        lua_pushcfunction(L, members_list[i].func);
        lua_setfield(L, start+1, members_list[i].name);
    }
}

int luaopen_osutils(lua L) {
    const luaL_Reg M[] = {
        {"openfile", openfile_dialog_l},
    };
    _outil_register(L, M, sizeof(M)/sizeof(luaL_Reg));
    return 1;
}
