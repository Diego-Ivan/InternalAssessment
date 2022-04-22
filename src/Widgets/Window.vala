/* window.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


namespace InternalAssessment {
    [GtkTemplate (ui = "/io/github/diegoivan/internalassessment/window.ui")]
    public class Window : Gtk.ApplicationWindow {
        public Adw.TimedAnimation animation { get; private set; }

        [GtkChild]
        private unowned Gtk.ProgressBar level_bar;
        [GtkChild]
        private unowned Gtk.Button run_button;
        [GtkChild]
        private unowned Adw.ComboRow animation_row;
        [GtkChild]
        private unowned Gtk.SpinButton duration;
        [GtkChild]
        private unowned RecordList record_list;
        [GtkChild]
        private unowned Adw.ViewStackPage records_view;
        [GtkChild]
        private unowned Adw.ToastOverlay toast_overlay;

        private DateTime start;

        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {
            var target = new Adw.CallbackAnimationTarget (animation_target);
            animation = new Adw.TimedAnimation (level_bar,
                0, 1, 10,
                target
            );
            animation.done.connect (on_animation_done);

            duration.value = 2;
        }

        [GtkCallback]
        private void on_run_button_clicked () {
            record_list.clear_list ();
            run_button.sensitive = false;
            records_view.needs_attention = false;

            var item = animation_row.selected_item as Adw.EnumListItem;
            animation.easing = (Adw.Easing) item.value;
            animation.duration = (uint) duration.value * 1000;

            start = new DateTime.now_local ();
            animation.play ();
        }

        private void on_animation_done () {
            run_button.sensitive = true;
            records_view.needs_attention = true;
            record_list.current_view = "records";
        }

        private void animation_target (double v) {
            level_bar.fraction = v;

            var date = new DateTime.now_local ();
            TimeSpan dif = date.difference (start);

            record_list.append_record (dif, v);
        }

        internal void send_toast (string message) {
            toast_overlay.add_toast (new Adw.Toast (message));
        }
    }
}
