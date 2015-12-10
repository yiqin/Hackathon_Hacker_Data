namespace java edu.uchicago.mpcs53013.weatherSummary

struct WeatherSummary {
	1: required i32 station;
	2: required i16 year;
	3: required byte month;
	4: required byte day;
	5: required double meanTemperature;
	6: required double meanVisibility;
	7: required double meanWindSpeed;
	8: required bool fog;
	9: required bool rain;
	10: required bool snow;
	11: required bool hail;
	12: required bool thunder;
	13: required bool tornado;
}

struct FlightSummary {
	1: required i16 year;
	2: required byte month;
	3: required byte day;
	4: required string carrier;
	5: required string origin;
	6: required string dest;
	8: required i64 dep_delay;
	9: required i64 arr_delay
}
