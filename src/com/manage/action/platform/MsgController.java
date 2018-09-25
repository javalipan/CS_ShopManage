package com.manage.action.platform;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Msg;
import com.manage.dao.model.MsgExample;
import com.manage.service.IMsgService;
import com.manage.util.Pager;

/**
 * 消息管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/msg")
public class MsgController extends BaseController{
	
	private final String urlprev="http://m.dsniang.com/";
	
	@Autowired
	private IMsgService msgService;

	@RequestMapping(value="/initMsgList.action")
	public String initMsgList(ModelMap model){
		return "msg/msgList";
	}
	
	@RequestMapping(value="/searchMsg.action")
	@ResponseBody
	public String searchMsg(Msg msg,Pager pager){
		MsgExample msgExample=new MsgExample();
		MsgExample.Criteria crit=msgExample.createCriteria();
		if(StringUtils.isNotBlank(msg.getTitle())){
			crit.andTitleLike("%"+msg.getTitle()+"%");
		}
		msgExample.setPager(pager);
		msgExample.setOrderByClause("fdorder asc");
		List<Msg> msgList=msgService.selectByExample(msgExample);
		int count=msgService.countByExample(msgExample);
		return DataGridJson(msgList,count);
	}
	
	@RequestMapping(value="/initMsgEdit.action")
	public String initMsgEdit(ModelMap model,Msg msg){
		model.put("urlprev", urlprev);
		if(StringUtils.isNotBlank(msg.getId())){
			msg=msgService.selectByPrimaryKey(msg.getId());
			model.put("msg", msg);
		}
		return "msg/msgEdit";
	}
	
	@RequestMapping(value="/saveMsg.action")
	@ResponseBody
	public String saveMsg(ModelMap model,Msg msg){
		msg.setPic(msg.getPicaddr());
		if(StringUtils.isNotBlank(msg.getId())){
			msgService.updateByPrimaryKeySelective(msg);
		}
		else{
			msg.setId(UUID.randomUUID().toString().replaceAll("-", ""));
			msgService.insertSelective(msg);
		}
		return "保存成功";
	}
	
	@RequestMapping(value="/deleteMsg.action")
	@ResponseBody
	public String deleteMsg(String ids){
		if(StringUtils.isBlank(ids)){
			return "删除失败";
		}
		String idarray[]=ids.split(",");
		List<String> idlist=new ArrayList<String>();
		for(String id:idarray){
			idlist.add(id);
		}
		MsgExample msgExample=new MsgExample();
		msgExample.createCriteria().andIdIn(idlist);
		if(msgService.deleteByExample(msgExample)>0){
			return "删除成功";
		}
		return "删除失败";
	}
}
