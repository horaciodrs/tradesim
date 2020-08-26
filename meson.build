project('com.github.horaciodrs.TradeSim', 'vala', 'c')

subdir('src')

executable(
	meson.project_name(),
	sources,
	dependencies: [
		dependency('gtk+-3.0')
		,dependency('glib-2.0')
		,dependency('granite', version: '>= 5.3.0')
	],
	install: true
)

subdir('data')

meson.add_install_script('meson/post_install.py')