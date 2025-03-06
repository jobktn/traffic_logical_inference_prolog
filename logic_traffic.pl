% Data for intersection traffic volumes (Intersection 3104)
% traffic_volume(Intersection, Volume, TimeInterval).
traffic_volume(3104, 2107, 1).
traffic_volume(3104, 2197, 3).
traffic_volume(3104, 2184, 6).
traffic_volume(3104, 2190, 12).
traffic_volume(3104, 2190, 18).

% Data for intersection traffic volumes (Intersection 3088)
traffic_volume(3088, 974, 1).
traffic_volume(3088, 960, 3).
traffic_volume(3088, 953, 6).
traffic_volume(3088, 953, 12).
traffic_volume(3088, 953, 18).

% Data for intersection traffic volumes (Intersection 3)
traffic_volume(3075, 613, 1).
traffic_volume(3075, 684, 3).
traffic_volume(3075, 732, 6).
traffic_volume(3075, 754, 12).
traffic_volume(3075, 756, 18).

% traffic_threshold(TimeOfDay, LowMax, MediumMax).
% Morning thresholds
traffic_threshold(morning, 999, 2000).     % Low: <=999, Medium: 1000-2000, High: >2000
% Afternoon thresholds
traffic_threshold(afternoon, 1499, 2500).  % Low: <=1499, Medium: 1500-2500, High: >2500
% Evening thresholds
traffic_threshold(evening, 1199, 2200).    % Low: <=1199, Medium: 1200-2200, High: >2200
% Night thresholds
traffic_threshold(night, 799, 1500).       % Low: <=799, Medium: 800-1500, High: >1500

% Define dynamic traffic conditions based on volume and time of day
dynamic_traffic_condition(Volume, TimeOfDay, low) :-
    traffic_threshold(TimeOfDay, LowMax, _),
    Volume =< LowMax.

dynamic_traffic_condition(Volume, TimeOfDay, medium) :-
    traffic_threshold(TimeOfDay, LowMax, MediumMax),
    Volume > LowMax,
    Volume =< MediumMax.

dynamic_traffic_condition(Volume, TimeOfDay, high) :-
    traffic_threshold(TimeOfDay, _, MediumMax),
    Volume > MediumMax.

% Define traffic advisories based on traffic level
traffic_advisory(low, 'No Congestion. Clear Intersection Ahead').
traffic_advisory(medium, 'Moderate Traffic. Expect Some Delays').
traffic_advisory(high, 'High Traffic. Consider Alternate Routes').

% Define times of day for simulation
% time_of_day(Hour, TimeOfDay)
time_of_day(Hour, morning) :-
    Hour >= 6,
    Hour < 12.

time_of_day(Hour, afternoon) :-
    Hour >= 12,
    Hour < 17.

time_of_day(Hour, evening) :-
    Hour >= 17,
    Hour < 21.

time_of_day(Hour, night) :-
    (Hour >= 21, Hour =< 24);
    (Hour >= 0, Hour < 6).

% Define dynamic traffic condition at an intersection, time interval, and time of day
dynamic_traffic_condition_at(Intersection, TimeInterval, TimeOfDay, Condition) :-
    traffic_volume(Intersection, Volume, TimeInterval),
    dynamic_traffic_condition(Volume, TimeOfDay, Condition).

% Define dynamic traffic advisory at an intersection, time interval, and time of day
dynamic_traffic_advisory_at(Intersection, TimeInterval, TimeOfDay, Advisory) :-
    dynamic_traffic_condition_at(Intersection, TimeInterval, TimeOfDay, Condition),
    traffic_advisory(Condition, Advisory).

% Simulation predicate to demonstrate how the dynamic model operates
simulate(Intersection, TimeInterval, Hour) :-
    time_of_day(Hour, TimeOfDay),
    traffic_volume(Intersection, Volume, TimeInterval),
    dynamic_traffic_advisory_at(Intersection, TimeInterval, TimeOfDay, Advisory),
    format('At ~w oclock in the ~w, intersection no. ~w, traffic volume for the next ~w hours is ~w cars. 
            The advisory is: ~s~n',
           [Hour, TimeOfDay, Intersection, TimeInterval, Volume, Advisory]).