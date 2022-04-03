/* RecordRow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace InternalAssessment {
    public class RecordRow : Adw.ActionRow {
        private DateTime _date;
        public DateTime date {
            get {
                return _date;
            }
            set {
                _date = value;
                subtitle = _date.format ("%H:%M:%S:%f");
            }
        }

        public string formatted_date {
            get {
                return subtitle;
            }
        }

        private double _recorded_value;
        public double recorded_value {
            get {
                return _recorded_value;
            }
            set {
                _recorded_value = value;
                title = value.to_string ();
            }
        }

        public RecordRow (DateTime d, double v) {
            Object (
                date: d,
                recorded_value: v
            );
        }

        construct {
            selectable = false;
        }
    }
}
