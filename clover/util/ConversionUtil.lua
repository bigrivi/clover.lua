local ConversionUtil = {}
local PI = 3.1415926
---
--- Converts milliseconds to seconds.
--- @param milliseconds: The number of milliseconds.
--- @return Returns the number of seconds.

function ConversionUtil.millisecondsToSeconds(milliseconds)
	return milliseconds/1000
end 


---
--- Converts milliseconds to minutes.
--- @param milliseconds: The number of milliseconds.
--- @return Returns the number of minutes.

function ConversionUtil.millisecondsToMinutes(milliseconds)
	return ConversionUtil.secondsToMinutes(ConversionUtil.millisecondsToSeconds(milliseconds));
end 


---
--- Converts milliseconds to hours.
--- @param milliseconds: The number of milliseconds.
--- @return Returns the number of hours.

function ConversionUtil.millisecondsToHours(milliseconds)
	return ConversionUtil.minutesToHours(ConversionUtil.millisecondsToMinutes(milliseconds));
end 


---
--- Converts milliseconds to days.
--- @param milliseconds: The number of milliseconds.
--- @return Returns the number of days.

function ConversionUtil.millisecondsToDays(milliseconds)
	return ConversionUtil.hoursToDays(ConversionUtil.millisecondsToHours(milliseconds)); 
end 


---
--- Converts seconds to minutes.
--- @param seconds: The number of seconds.
--- @return Returns the number of minutes.

function ConversionUtil.secondsToMinutes(seconds)
	return seconds/60
end 

---
--- Converts seconds to milliseconds.
--- @param seconds: The number of seconds.
--- @return Returns the number of milliseconds.

function ConversionUtil.secondsToMilliseconds(seconds)
	return seconds*1000
end 


---
--- Converts seconds to hours.
--- @param seconds: The number of seconds.
--- @return Returns the number of hours.

function ConversionUtil.secondsToHours(seconds)
	return ConversionUtil.minutesToHours(ConversionUtil.secondsToMinutes(seconds))
end 

---
--- Converts seconds to days.
--- @param seconds: The number of seconds.
--- @return Returns the number of days.

function ConversionUtil.secondsToDays(seconds)
	return ConversionUtil.hoursToDays(ConversionUtil.secondsToHours(seconds));
end 


---
--- Converts minutes to hours.
--- @param minutes: The number of minutes.
--- @return Returns the number of hours.

function ConversionUtil.minutesToHours(minutes)
	return minutes/60
end 


---
--- Converts minutes to secondss.
--- @param minutes: The number of minutes.
--- @return Returns the number of secondss.

function ConversionUtil.minutesToSeconds(minutes)
	return minutes*60
end 


---
--- Converts minutes to milliseconds.
--- @param minutes: The number of minutes.
--- @return Returns the number of secondss.

function ConversionUtil.minutesToMilliSeconds(minutes)
	return ConversionUtil.secondsToMilliseconds(ConversionUtil.minutesToSeconds(minutes))
end 

---
--- Converts minutes to days.
--- @param minutes: The number of minutes.
--- @return Returns the number of secondss.

function ConversionUtil.minutesToDays(minutes)
	return ConversionUtil.hoursToDays(ConversionUtil.minutesToHours(minutes));
end 

---
--- Converts hours to milliseconds.
--- @param hours: The number of hours.
--- @return Returns the number of milliseconds.

function ConversionUtil.hoursToMilliseconds(hours)
	return ConversionUtil.secondsToMilliseconds(ConversionUtil.hoursToSeconds(hours));
end 


---
--- Converts hours to seconds.
--- @param hours: The number of hours.
--- @return Returns the number of seconds.

function ConversionUtil.hoursToSeconds(hours)
	return ConversionUtil.minutesToSeconds(ConversionUtil.hoursToMinutes(hours));
end 


---
--- Converts hours to minutes.
--- @param hours: The number of hours.
--- @return Returns the number of minutes.

function ConversionUtil.hoursToMinutes(hours)
	return hours*60
end 


---
--- Converts hours to days.
--- @param hours: The number of hours.
--- @return Returns the number of days.

function ConversionUtil.hoursToDays(hours)
	return hours/24
end 

---
--- Converts days to milliseconds.
--- @param days: The number of days.
--- @return Returns the number of milliseconds.

function ConversionUtil.daysToMilliseconds(days)
	return  ConversionUtil.secondsToMilliseconds(ConversionUtil.daysToSeconds(days));
end 

---
--- Converts days to seconds.
--- @param days: The number of days.
--- @return Returns the number of seconds.

function ConversionUtil.daysToSeconds(days)
	return ConversionUtil.minutesToSeconds(ConversionUtil.daysToMinutes(days));
end 


---
--- Converts days to minutes.
--- @param days: The number of days.
--- @return Returns the number of minutes.

function ConversionUtil.daysToMinutes(days)
	return ConversionUtil.hoursToMinutes(ConversionUtil.daysToHours(days));
end 


---
--- Converts days to hours.
--- @param days: The number of days.
--- @return Returns the number of hours.

function ConversionUtil.daysToHours(days)
	return days*24
end 

---
--- Converts degrees to radians.
--- @param degrees: The number of degrees.
--- @return Returns the number of radians.

function ConversionUtil.degreesToRadians(degrees)
	return degrees * (PI/180)
end 

---
--- Converts degrees to radians.
--- @param degrees: The number of degrees.
--- @return Returns the number of radians.

function ConversionUtil.radiansToDegrees(radians)
	return degrees * (180/PI)
end 

return 