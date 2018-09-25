package com.manage.action.content;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Content;
import com.manage.dao.model.ContentExample;
import com.manage.service.IContentService;
import com.manage.util.Pager;

@Controller
@RequestMapping(value="/content")
public class ContentController extends BaseController{
	
	@Autowired
	private IContentService contentService;
	
	@RequestMapping(value="/initContentMain.action")
	public String initContentMain(ModelMap model){
		return "content/contentMain";
	}

	@RequestMapping(value="/initContentList.action")
	public String initContentList(ModelMap model,String programid){
		model.put("programid", programid);
		return "content/contentList";
	}
	
	@RequestMapping(value="/searchContentData.action")
	@ResponseBody
	public String searchContentData(Content content,Pager pager){
		ContentExample contentExample=new ContentExample();
		ContentExample.Criteria crit=contentExample.createCriteria();
		if(content.getProgramid()!=null){
			crit.andProgramidEqualTo(content.getProgramid());
		}
		if(StringUtils.isNotBlank(content.getTitle())){
			crit.andTitleEqualTo("%"+content.getTitle()+"%");
		}
		contentExample.setOrderByClause("createtime desc");
		contentExample.setPager(pager);
		List<Content> contents=contentService.selectByExample(contentExample);
		int count=contentService.countByExample(contentExample);
		return DataGridJson(contents, count);
	}
	
	@RequestMapping(value="/initContentEdit.action")
	public String initContentEdit(ModelMap model,Content content){
		if(content!=null&&content.getId()!=null){
			content=contentService.selectByPrimaryKey(content.getId());
			model.put("content", content);
		}
		return "content/contentEdit";
	}
	
	@RequestMapping(value="/saveContent.action")
	@ResponseBody
	public String saveContent(ModelMap model,Content content){
		content.setUpdatetime(new Date());
		if(content.getId()==null){		//添加
			content.setCreatetime(new Date());
			contentService.insertSelective(content);
		}
		else{		//修改
			contentService.updateByPrimaryKeySelective(content);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteContent.action")
	@ResponseBody
	public String deleteContent(String ids){
		if(StringUtils.isBlank(ids)){
			return "删除失败";
		}
		List<Long> idlist=new ArrayList<Long>();
		String[] idarray=ids.split(",");
		for(String id:idarray){
			idlist.add(Long.parseLong(id));
		}
		ContentExample contentExample=new ContentExample();
		contentExample.createCriteria().andIdIn(idlist);
		contentService.deleteByExample(contentExample);
		return "删除成功";
	}
}
