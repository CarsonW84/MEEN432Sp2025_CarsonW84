% Project 4 - Week 3 master
run clear
run Project_4_Model
run p4_init.m
run plot_track

% Run raceStat analysis
[laps_completed, total_laps, lap_times, total_time, out_of_bounds] = raceStat(car.X_data, car.Y_data, Time, track_data, car.SOC);