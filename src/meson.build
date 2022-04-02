internal_assesment_sources = [
  'main.vala',
  'Window.vala',
  'Application.vala',
]

internal_assesment_deps = [
  dependency('libadwaita-1', version: '>= 1.0'),
  dependency('gtk4', version: '>= 4.5.0'),
]

app_id = 'io.github.diegoivan.internalassesment'

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('G_LOG_DOMAIN', 'InternalAssesment')
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
configure_file(output: 'config.h', configuration: conf)

add_project_arguments(
    '-include', 'config.h',
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

gnome = import('gnome')

resources_file = files('resources/internal_assesment.gresource.xml')
internal_assesment_sources += gnome.compile_resources(app_id,
  resources_file,
  c_name: 'internalassesment',
  source_dir: 'resources',
)

executable('internal-assesment', internal_assesment_sources,
  vala_args: [
    meson.project_source_root() + '/src/vapi/Config.vapi',
    '--target-glib=2.50',
    '--gresources', resources_file,
    '--vapidir', meson.project_source_root() / 'vapi',
  ],
  dependencies: internal_assesment_deps,
  install: true,
)
