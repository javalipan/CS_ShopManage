package com.manage.action.platform;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Schedule;
import com.manage.dao.model.ScheduleExample;
import com.manage.service.IMemberService;
import com.manage.service.IScheduleService;

/**
 * 预约管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/appoint")
public class AppointmentController extends BaseController{
	
	@Autowired
	private IScheduleService scheduleService;
	@Autowired
	private IMemberService memberService;

	@RequestMapping(value="/initAppointment.action")
	public String initAppointment(ModelMap model){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		model.put("now", sdf.format(new Date()));
		return "appointment/appointmentMain";
	}
	
	@RequestMapping(value="/getAppointment.action")
	@ResponseBody
	public String getAppointment(String start,String end) throws ParseException{
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date startDate=sdf.parse(start);
//		Date endDate=sdf.parse(end);
		ScheduleExample scheduleExample=new ScheduleExample();
		ScheduleExample.Criteria crit= scheduleExample.createCriteria();
		crit.andStarttimeGreaterThanOrEqualTo(startDate);
//		crit.andEndtimeLessThanOrEqualTo(endDate);
		List<Schedule> schedules=scheduleService.selectByExample(scheduleExample);
		System.out.println(schedules.size());
		List<Map<String, Object>> result=new ArrayList<Map<String,Object>>();
		for(Schedule schedule:schedules){
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("title", schedule.getName()+","+schedule.getAddress());
			map.put("start", sdf2.format(schedule.getStarttime()));
			if(schedule.getEndtime()!=null){
				map.put("end", sdf2.format(schedule.getEndtime()));
			}
			if("0".equals(schedule.getType())){
				map.put("color", "#49d073");
			}
			else{
				map.put("color", "#3498DB");
			}
			map.put("id", schedule.getId());
			map.put("phone", schedule.getPhone());
			map.put("address", schedule.getAddress());
			map.put("remark", schedule.getRemark());
			map.put("name", schedule.getName());
			result.add(map);
		}
		return JSONArray.fromObject(result).toString();
	}
	
	@RequestMapping(value="/initEditAppointment.action")
	public String initEditAppointment(ModelMap model,Schedule schedule){
		if(schedule.getId()!=null){
			schedule=scheduleService.selectByPrimaryKey(schedule.getId());
			model.put("schedule", schedule);
		}
		return "appointment/editAppointment";
	}
	
	@RequestMapping(value="/saveAppointment.action")
	@ResponseBody
	public String saveAppointment(Schedule schedule){
		if(schedule.getId()==null){
			schedule.setType("0");
			schedule.setCreatetime(new Date());
			schedule.setCreater(getSessionInfo().getName());
			scheduleService.insertSelective(schedule);
		}
		else{
			scheduleService.updateByPrimaryKeySelective(schedule);
		}
		return "保存成功";
	}
}
