package com.manage.action.statistical;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.service.IOrderService;

/**
 * 新老顾客统计
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/statistic/orn")
public class OldNewStatisticalController extends BaseController{
	
	@Autowired
	private IOrderService orderService;

	@RequestMapping(value="/index.action")
	public String index(ModelMap model){
		return "statistic/ornStatistical";
	}
	
	@RequestMapping(value="/sumByOldOrNew.action")
	@ResponseBody
	public String sumByOldOrNew(String year){
		List<Map<String, Object>> list=orderService.sumByOldOrNew(year);
		return JSONArray.fromObject(list).toString();
	}
	
}
