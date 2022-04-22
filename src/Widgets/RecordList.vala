/* RecordList.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace InternalAssessment {
    [GtkTemplate (ui = "/io/github/diegoivan/internalassessment/recordlist.ui")]
    public class RecordList : Adw.Bin {
        public string current_view {
            get {
                return view_stack.visible_child_name;
            }
            set {
                view_stack.visible_child_name = value;
            }
        }

        [GtkChild]
        private unowned ListStore liststore;
        [GtkChild]
        private unowned Gtk.SignalListItemFactory factory;
        [GtkChild]
        private unowned Gtk.ListView listview;

        [GtkChild]
        private unowned Gtk.Stack view_stack;
        private Gtk.FileChooserNative? filechooser;

        private const ActionEntry[] ENTRIES = {
            { "delete-all", clear_list },
            { "generate-image", generate_image }
        };

        static construct {
            typeof(RecordObject).ensure ();
        }

        construct {
            filechooser = new Gtk.FileChooserNative (null,
                get_native () as Gtk.Window,
                SAVE,
                null,
                null
            );
            filechooser.response.connect (on_filechooser_response);

            var action_group = new SimpleActionGroup ();
            action_group.add_action_entries (ENTRIES, this);
            insert_action_group ("recordlist", action_group);

            factory.bind.connect ((o) => {
                o.child = new RecordRow ((RecordObject) o.item);
            });
            listview.remove_css_class ("view");
            listview.add_css_class ("background");
        }

        public void append_record (TimeSpan ts, double v) {
            var o = new RecordObject () {
                timespan = ts,
                recorded_value = v
            };
            liststore.append (o);
        }

        public void clear_list () {
            liststore.remove_all ();
            view_stack.set_visible_child_name ("empty");
        }

        [GtkCallback]
        private void on_save_button_clicked () {
            var filters = new Gtk.FileFilter ();
            filters.add_suffix ("csv");

            filechooser.show ();
        }

        public void on_filechooser_response (int res) {
            if (res == Gtk.ResponseType.ACCEPT) {
                save_as_csv.begin (on_file_saved);
            }
        }

        private async void save_as_csv () {
            string format = "timespan,value";
            for (int i = 0; i < liststore.get_n_items (); i++) {
                RecordObject o = (RecordObject) liststore.get_object (i);
                format += "\n\"%s\",\"%s\"".printf (o.timespan.to_string (), o.recorded_value.to_string ());
            }

            try {
                string path = filechooser.get_file ().get_path ();
                FileUtils.set_contents (path, format);
            }
            catch (Error e) {
                critical (e.message);
            }
        }

        private void on_file_saved () {
            var win = get_native () as Window;
            win.send_toast ("File Successfully Saved");
        }

        private void generate_image () {
            var image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, 1000, 500);
            var ctx = new Cairo.Context (image_surface);

            ctx.set_source_rgba (0, 0, 0, 1);
            ctx.set_line_width (200);
            ctx.move_to (30, 0);
            ctx.line_to (30, 1000);
            ctx.stroke ();

            var chooser = new Gtk.FileChooserNative (null,
                get_native () as Gtk.Window,
                SAVE,
                null,
                null
            );
            chooser.response.connect ((res) => {
                if (res == Gtk.ResponseType.ACCEPT) {
                    image_surface.write_to_png (chooser.get_file ().get_path ());
                }
            });

            chooser.show ();
        }
    }
}
