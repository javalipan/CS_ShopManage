package com.manage.action.content;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.ContentExample;
import com.manage.dao.model.Program;
import com.manage.dao.model.ProgramExample;
import com.manage.query.model.TreeNode;
import com.manage.service.IContentService;
import com.manage.service.IProgramService;

@Controller
@RequestMapping(value="/program")
public class ProgramController extends BaseController{
	
	@Autowired
	private IProgramService programService;
	@Autowired
	private IContentService contentService;

	@RequestMapping(value="/initProgramList.action")
	public String initProgramList(){
		return "program/programList";
	}
	
	@RequestMapping(value="/searchProgramData.action")
	@ResponseBody
	public String searchProgramData(String id){
		ProgramExample programExample=new ProgramExample();
		programExample.setOrderByClause("sortno asc");
		List<Program> programs=programService.selectByExample(programExample); 
		List<TreeNode> treenodes=new ArrayList<TreeNode>();
		for(Program p:programs){
			TreeNode treeNode=new TreeNode();
			treeNode.setId(p.getId().toString());
			treeNode.setName(p.getName());
			treeNode.setParentid(p.getParentid().toString());
			treeNode.setChecked("false");
			treeNode.setState("open");
			treeNode.setAttributes(JSONObject.fromObject(p));
			treenodes.add(treeNode);
		}
		return super.list2easyUiTreeData(treenodes, "id", "name", "parentid", "state", "checked", true);
	}
	
	@RequestMapping(value="/initProgramEdit.action")
	public String initProgramEdit(ModelMap model,Program program){
		if(program!=null&&program.getId()!=null){
			program=programService.selectByPrimaryKey(program.getId());
			model.put("program", program);
		}
		return "program/programEdit";
	}
	
	@RequestMapping(value="/saveProgram.action")
	@ResponseBody
	public String saveProgram(ModelMap model,Program program){
		if(program.getParentid()==null){
			program.setParentid((long)0);
		}
		if(program.getId()==null){		//添加
			program.setCreatetime(new Date());
			program.setUpdatetime(new Date());
			programService.insertSelective(program);
		}
		else{		//修改
			program.setUpdatetime(new Date());
			programService.updateByPrimaryKeySelective(program);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteProgram.action")
	@ResponseBody
	public String deleteProgram(Long id){
		if(id==null){
			return "删除失败";
		}
		ContentExample contentExample=new ContentExample();
		contentExample.createCriteria().andProgramidEqualTo(id);
		if(contentService.countByExample(contentExample)>0){
			return "该栏目下有内容，删除失败";
		}
		programService.deleteByPrimaryKey(id);
		return "删除成功";
	}
}
