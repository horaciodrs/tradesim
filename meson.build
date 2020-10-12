project('com.github.horaciodrs.TradeSim', 'vala', 'c')

i18n = import('i18n')

# Include the gnome module
gnome = import('gnome')
asresources = gnome.compile_resources(
    'as-resources', 'data/com.github.horaciodrs.tradesim.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subdir('src')

deps = [
 	 dependency('gtk+-3.0')
	,dependency('glib-2.0')
	,dependency('sqlite3')
  ,dependency('libxml-2.0')
	,dependency('granite', version: '>= 5.3.0')
]

executable(
	meson.project_name(),
	asresources,
	sources,
	dependencies: deps,
	install: true
)

subdir('data')

meson.add_install_script('meson/post_install.py')
