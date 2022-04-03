/* RecordList.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace InternalAssesment {
    [GtkTemplate (ui = "/io/github/diegoivan/internalassesment/recordlist.ui")]
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

        public void append_record (DateTime date, double record) {
            var row = new Adw.ActionRow () {
                title = date.format ("%H:%M:%S:%f"),
                subtitle = record.to_string (),
                title_selectable = true
            };
            listbox.append (row);
        }

        public void clear_list () {
            Gtk.ListBoxRow? row = listbox.get_row_at_index (0);
            while (row != null) {
                listbox.remove (row);
                row = listbox.get_row_at_index (0);
            }
        }

        [GtkCallback]
        private void on_save_button_clicked () {
        }

        public void data_to_csv (File file) {
        }
    }
}
