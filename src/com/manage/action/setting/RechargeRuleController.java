package com.manage.action.setting;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.RechargeRule;
import com.manage.dao.model.RechargeRuleExample;
import com.manage.service.IRechargeRuleService;
import com.manage.util.Pager;

/**
 * 充值规则设置
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/rechargerule")
public class RechargeRuleController extends BaseController{

	@Autowired
	private IRechargeRuleService rechargeRuleService;
	
	@RequestMapping(value="/initRechargeRuleList.action")
	public String initRechargeRuleList(){
		return "rule/rechargerulelist";
	}
	
	@RequestMapping(value="/searchRechargeRules.action")
	@ResponseBody
	public String searchRechargeRules(ModelMap model,RechargeRule rechargerule,Pager pager){
		RechargeRuleExample rechargeRuleExample=new RechargeRuleExample();
		rechargeRuleExample.setPager(pager);
		int count=rechargeRuleService.countByExample(rechargeRuleExample);
		List<RechargeRule> rechargeruleList=rechargeRuleService.selectByExample(rechargeRuleExample);
		return DataGridJson(rechargeruleList, count);
	}
	
	@RequestMapping(value="/saveRechargeRule.action")
	@ResponseBody
	public String saveRechargeRule(ModelMap model,RechargeRule rechargerule){
		if(rechargerule.getId()==null){		//添加
			rechargeRuleService.insertSelective(rechargerule);
		}
		else{		//修改
			rechargeRuleService.updateByPrimaryKeySelective(rechargerule);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteRechargeRule.action")
	@ResponseBody
	public String deleteRechargeRule(ModelMap model,Long id){
		rechargeRuleService.deleteByPrimaryKey(id);
		return "删除成功";
	}
}
