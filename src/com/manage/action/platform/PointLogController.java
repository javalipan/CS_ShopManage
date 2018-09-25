package com.manage.action.platform;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.query.model.PointLogQuery;
import com.manage.service.IPointLogService;
import com.manage.util.Pager;

/**
 * 积分日志管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/pointLog")
public class PointLogController extends BaseController{

	@Autowired
	private IPointLogService pointLogService;
	
	@RequestMapping(value="/initPointLogList.action")
	public String initPointLogList(ModelMap model,String memberid){
		if(StringUtils.isNotBlank(memberid)){
			model.put("memberid", memberid);
		}
		else{
			model.put("memberid", "");
		}
		return "pointLog/pointLoglist";
	}
	
	@RequestMapping(value="/searchPointLogs.action")
	@ResponseBody
	public String searchPointLogs(ModelMap model,PointLogQuery pointLogQuery,Pager pager){
		pointLogQuery.setOrderBy("pl.changeTime desc");
		pointLogQuery.setPager(pager);
		int count=pointLogService.countByPointLogQuery(pointLogQuery);
		List<PointLogQuery> list=pointLogService.selectByPointLogQuery(pointLogQuery);
		return DataGridJson(list, count);
	}
}
