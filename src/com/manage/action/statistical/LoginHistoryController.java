package com.manage.action.statistical;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.service.ILoginHistoryService;

/**
 * 公总号访问统计
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/loginHis")
public class LoginHistoryController extends BaseController{
	
	@Autowired
	private ILoginHistoryService loginHistoryService;

	@RequestMapping(value="/initLoginHistory.action")
	public String initLoginHistory(ModelMap model){
		return "statistic/loginHistory";
	}
	
	@RequestMapping(value="/getLoginHistory.action")
	@ResponseBody
	public String getLoginHistory(String startTime,String endTime){
		Calendar calendar=Calendar.getInstance();
		calendar.add(Calendar.HOUR_OF_DAY, -24);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if(StringUtils.isBlank(startTime)&&StringUtils.isBlank(endTime)){
			startTime=sdf.format(calendar.getTime());
			endTime=sdf.format(new Date());
		}
		List<Map<String,Object>> maps=loginHistoryService.sumLoginHistory(startTime, endTime);
		JSONObject result=new JSONObject();
		JSONArray x=new JSONArray();
		JSONArray y=new JSONArray();
		for(Map<String, Object> map:maps){
			x.add(map.get("logtime"));
			y.add(map.get("cnt"));
		}
		result.put("x", x);
		result.put("y", y);
		return JSONObject.fromObject(result).toString();
	}
	
}
