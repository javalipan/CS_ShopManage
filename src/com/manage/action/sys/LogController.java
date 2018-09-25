package com.manage.action.sys;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.query.model.HistoryLogQuery;
import com.manage.service.ILogService;
import com.manage.util.Pager;

/**
 * 日志
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/log")
public class LogController extends BaseController{

	@Autowired
	private ILogService logService;
	
	@RequestMapping(value="/initLogPage.action")
	public String initLogPage(ModelMap model){
		return "log/loglist";
	}
	
	@RequestMapping(value="/searchLog.action")
	@ResponseBody
	public String searchLog(ModelMap model,HistoryLogQuery historyLogQuery,Pager pager){
		historyLogQuery.setPager(pager);
		List<HistoryLogQuery> historyLogQueries=logService.selectByHistoryLogQuery(historyLogQuery);
		return DataGridJson(historyLogQueries, logService.countByHistoryLogQuery(historyLogQuery));
	}
}
