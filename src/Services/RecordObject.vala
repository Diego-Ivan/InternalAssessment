/* RecordObject.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace InternalAssessment {
    public class RecordObject : Object {
        private TimeSpan _timespan;
        public TimeSpan timespan {
            get {
                return _timespan;
            }
            set {
                _timespan = value;
            }
        }

        private double _recorded_value;
        public double recorded_value {
            get {
                return _recorded_value;
            }
            set {
                _recorded_value = value;
            }
        }
    }
}
