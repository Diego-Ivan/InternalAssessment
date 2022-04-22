/* RecordRow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace InternalAssessment {
    [GtkTemplate (ui = "/io/github/diegoivan/internalassessment/recordrow.ui")]
    public class RecordRow : Adw.Bin {
        [GtkChild]
        private unowned Gtk.Label value_label;
        [GtkChild]
        private unowned Gtk.Label timespan_label;

        public TimeSpan timespan {
            set {
                timespan_label.label = value.to_string ();
            }
        }
        public double recorded_value {
            set {
                value_label.label = value.to_string ();
            }
        }

        public RecordRow (RecordObject o) {
            Object (
                timespan: o.timespan,
                recorded_value: o.recorded_value
            );
        }
    }
}
