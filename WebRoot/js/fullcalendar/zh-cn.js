
$.fullCalendar.locale("zh-cn", {
	buttonText: {
		month: "月",
		week: "周",
		day: "日",
		list: "日程",
		today:"今天"
	},
	monthNames:['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
    monthNamesShort:['一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二'],
	dayNames:['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
	dayNamesShort:['日', '一', '二', '三', '四', '五', '六'],
	weekNumberTitle:'星期',
	eventLimitText:'更多',
	allDayText: "全天",
	eventLimitText: function(n) {
		return "另外 " + n + " 个";
	},
	noEventsMessage: "没有事件显示"
});
