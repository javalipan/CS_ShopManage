package com.manage.action.setting;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jfinal.kit.HttpKit;
import com.manage.action.BaseController;
import com.manage.constant.CommonConstant;

@Controller
@RequestMapping(value="/data")
public class DataManageController extends BaseController{

	@RequestMapping(value="/index.action")
	public String index(){
		return "rule/dataManage";
	}
	
	@RequestMapping(value="/initData.action")
	@ResponseBody
	public String initData(String url){
		HttpKit.get(CommonConstant.WEIXIN_URL+url);
		return "操作成功!";
	}
}
