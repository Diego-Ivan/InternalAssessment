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
        private unowned Gtk.ListBox listbox;
        [GtkChild]
        private unowned Gtk.Stack view_stack;
        private Gtk.FileChooserNative? filechooser;

        private const ActionEntry[] ENTRIES = {
            { "delete-all", clear_list },
            { "generate-image", generate_image }
        };

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
        }

        public void append_record (DateTime date, double record) {
            var row = new RecordRow (date, record);
            listbox.append (row);
        }

        public void clear_list () {
            Gtk.ListBoxRow? row = listbox.get_row_at_index (0);
            while (row != null) {
                listbox.remove (row);
                row.dispose ();
                row = listbox.get_row_at_index (0);
            }
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
            string records = "datetime,value\n";
            File file = filechooser.get_file ();

            int i = 0;
            RecordRow row = listbox.get_row_at_index (0) as RecordRow;
            while (row != null) {
                records += "\"%s\",\"%f\"\n".printf (row.formatted_date, row.recorded_value);
                i++;
                row = listbox.get_row_at_y (i) as RecordRow;
            }

            try {
                FileUtils.set_contents (file.get_path (), records);
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
