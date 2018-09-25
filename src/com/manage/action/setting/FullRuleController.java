package com.manage.action.setting;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.FullRule;
import com.manage.dao.model.FullRuleExample;
import com.manage.service.IFullRuleService;
import com.manage.util.Pager;

/**
 * 满减规则设置
 * @author pan
 *
 */
@Controller
@RequestMapping(value="/fullrule")
public class FullRuleController extends BaseController{

	@Autowired
	private IFullRuleService fullRuleService;
	
	@RequestMapping(value="/initFullRuleList.action")
	public String initFullRuleList(){
		return "rule/fullrulelist";
	}
	
	@RequestMapping(value="/searchFullRules.action")
	@ResponseBody
	public String searchFullRules(ModelMap model,FullRule fullrule,Pager pager){
		FullRuleExample fullRuleExample=new FullRuleExample();
		fullRuleExample.setPager(pager);
		int count=fullRuleService.countByExample(fullRuleExample);
		List<FullRule> fullruleList=fullRuleService.selectByExample(fullRuleExample);
		return DataGridJson(fullruleList, count);
	}
	
	@RequestMapping(value="/saveFullRule.action")
	@ResponseBody
	public String saveFullRule(ModelMap model,FullRule fullrule){
		if(fullrule.getId()==null){		//添加
			fullRuleService.insertSelective(fullrule);
		}
		else{		//修改
			fullRuleService.updateByPrimaryKeySelective(fullrule);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteFullRule.action")
	@ResponseBody
	public String deleteFullRule(ModelMap model,Long id){
		fullRuleService.deleteByPrimaryKey(id);
		return "删除成功";
	}
}
