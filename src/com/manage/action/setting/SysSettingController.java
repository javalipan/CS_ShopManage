package com.manage.action.setting;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.SysSetting;
import com.manage.dao.model.SysSettingExample;
import com.manage.service.ISysSettingService;

/**
 * 系统参数设置
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="set")
public class SysSettingController extends BaseController{

	@Autowired
	private ISysSettingService sysSettingService;
	
	@RequestMapping(value="/initSetting.action")
	public String initSetting(ModelMap model){
		SysSettingExample settingExample=new SysSettingExample();
		List<SysSetting> sysSettings=sysSettingService.selectByExample(settingExample);
		model.put("sysSettings", sysSettings);
		return "rule/setting";
	}
	
	@RequestMapping(value="/saveSetting.action")
	@ResponseBody
	public String saveSetting(String json){
		JSONArray jsonArray=JSONArray.fromObject(json);
		for(int i=0;i<jsonArray.size();i++){
			JSONObject obj=jsonArray.getJSONObject(i);
			SysSetting setting=new SysSetting();
			setting.setId(obj.getLong("id"));
			setting.setTypevalue(obj.getString("optvalue"));
			sysSettingService.updateByPrimaryKeySelective(setting);
		}
		return "保存成功";
	}
}
