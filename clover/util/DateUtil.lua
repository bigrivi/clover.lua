local M = {}

---
-- @function toDate 
-- @param #int seconds time in seconds 
-- @return #int hour,min,sec
function M.toDate(seconds)

    local hour,min,sec = 0,0,0
    seconds = math.floor(seconds)
    sec = seconds % 60
    min = math.floor((seconds/60)%60)
    hour = math.floor(seconds / 3600)
    return hour, min, sec
end

---
-- @function toDateString 
-- @param #int seconds time in seconds 
-- @return #string %02d:%02d:%02d
function M.toDateString(seconds)
    
    return string.format("%02d:%02d:%02d",M.toDate(seconds))
end

----
-- @function Converts the month number into the full month name
-- @param month: The month number (0 for January, 1 for February, and so on).
-- @return Returns a full textual representation of a month, such as January or March.

function M.getMonthAsString(month)
	local monthNamesFull = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'}
	return monthNamesFull[month];
end 

return M
