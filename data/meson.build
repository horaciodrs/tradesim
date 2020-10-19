icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        join_paths('icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )

    install_data(
        join_paths('icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'mimetypes')
    )

    #install_data(
    #    join_paths('icons', i, meson.project_name() + '.svg'),
    #    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
    #)
endforeach

#Translate and install our .desktop file
i18n.merge_file(
    input: meson.project_name() + '.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Translate and install our .appdata file
i18n.merge_file(
    input: meson.project_name() + '.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

#############################3333

###--->>>>WARNING FIX IT WHEN TRANSLATIONS ARE DONE<<<----###

#install_data(
#    'com.github.horaciodrs.TradeSim.desktop',
#    install_dir: join_paths(get_option('datadir'), 'applications')
#)

#install_data(
#    'com.github.horaciodrs.TradeSim.appdata.xml',
#    install_dir: join_paths(get_option('datadir'), 'metainfo')
#)

###########-->>>fix end<<<----#######################

install_data(
    'com.github.horaciodrs.tradesim.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

install_data(
    'css/artboard.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/colors.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/dialogs.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/headerbar.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/layer.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/layout.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/option-panel.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/stylesheet.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'css/variables.css',
    install_dir: join_paths(get_option('datadir'), 'com.github.horaciodrs.TradeSim')
)

install_data(
    'com.github.horaciodrs.tradesim.mime.xml',
    install_dir: join_paths(get_option('datadir'), 'mime', 'packages')
)
