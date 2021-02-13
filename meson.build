project('com.github.horaciodrs.tradesim', 'vala', 'c')

i18n = import('i18n')
# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Include the gnome module
gnome = import('gnome')
asresources = gnome.compile_resources(
    'as-resources', 'data/com.github.horaciodrs.tradesim.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subdir('src')

cc = meson.get_compiler('c')

deps = [
 	 dependency('gtk+-3.0')
	,dependency('glib-2.0')
	,dependency('sqlite3')
    ,dependency('libxml-2.0')
	,dependency('granite', version: '>= 5.3.0')
	,cc.find_library('m', required : false)
]

executable(
	meson.project_name(),
	asresources,
	sources,
	dependencies: deps,
	install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
