project('osutils', ['c', 'cpp'], version: '0.2', default_options: ['c_std=c11', 'build.c_std=c11'])


lua = dependency('lua', required: false)

if not lua.found()
  lua = subproject('lua', required: true).get_variable('lua_dep')
endif

adddeps = []
source = files('osutils.c')
if host_machine.system() == 'windows'
  cc = meson.get_compiler('c')
  adddeps += cc.find_library('propsys') 
  adddeps += cc.find_library('shlwapi') 
  adddeps += cc.find_library('comctl32') 
  source += 'windows-osutils.cpp'
endif

# If you use any *BSD and have an XDG environment running DBUS, use this option.
if ['linux', 'gnu'].contains(host_machine.system()) or get_option('force_xdg')
  adddeps += dependency('gio-2.0', required: true)
  source += 'xdg-osutils.c'
endif

if get_option('buildtype') == 'debug'
  add_project_arguments('-DDEBUG', language: 'c')
  add_project_arguments('-DDEBUG', language: 'cpp')
endif

library('osutils', source, dependencies: [lua] + adddeps)
