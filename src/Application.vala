/* Application.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace InternalAssesment {
    public class Application : Adw.Application {
        private const ActionEntry[] action_entries = {
            { "about", on_about_action },
            { "preferences", on_preferences_action },
            { "quit", quit }
        };

        public Application () {
            Object (
                application_id: "io.github.diegoivan.internalassesment",
                flags: ApplicationFlags.FLAGS_NONE
            );

            resource_base_path = "/io/github/diegoivan/internalassesment";
        }

        construct {
            add_action_entries (action_entries, this);
            set_accels_for_action ("app.quit", {"<primary>q"});
        }

        public override void activate () {
            base.activate ();
            var win = active_window;
            if (win == null) {
                win = new Window (this);
            }
            win.present ();
        }

        private void on_about_action () {
            const string COPYRIGHT = "Copyright \xc2\xa9 2022 Diego Iván";
            const string?[] AUTHORS = {
                "Diego Iván<diegoivan.mae@gmail.com>",
                null
            };

            Gtk.show_about_dialog (active_window,
                "program_name", "Internal Assessment",
                "logo-icon-name", Config.APP_ID,
                "version", Config.VERSION,
                "copyright", COPYRIGHT,
                "authors", AUTHORS,
                "license-type", Gtk.License.GPL_3_0,
                "wrap-license", true,
                null
            );
        }

        private void on_preferences_action () {
            message ("app.preferences action activated");
        }
    }
}
