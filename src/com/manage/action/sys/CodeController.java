package com.manage.action.sys;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Code;
import com.manage.dao.model.CodeExample;
import com.manage.query.model.TreeNode;
import com.manage.service.ICodeService;
import com.manage.util.Pinyin4jUtil;
import com.manage.util.ReturnJsonData;

/**
 * 码表管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/code")
public class CodeController extends BaseController{
	
	@Autowired
	private ICodeService codeService;

	@RequestMapping(value="/initDictTree.action")
	public String initDictTree(ModelMap model) {
		return "tool/dicttree";
	}
	
	/**
	 * 异步加载字典数据
	 * @param model
	 * @param id : 父级id，如果不传加载第一级
	 * @param type : 本级code，如果不为空则加载第三级及以上
	 * @return
	 */
	@RequestMapping(value="/getTreeData.do")
	@ResponseBody
	public String getTreeData(ModelMap model,String id,String type){
		List<Code> result = null;
		List<TreeNode> treeNode=new ArrayList<TreeNode>();
		if(StringUtils.isBlank(id)){		//第一级
			result=codeService.getTypeList();
			for(Code sd:result){
				TreeNode td=new TreeNode();
				td.setId(sd.getTypecode());
				td.setName(sd.getTypename());
				td.setParentid(sd.getParentid());
				td.setAttributes(JSONObject.fromObject(sd));
				treeNode.add(td);
			}
		}
		else{
			if(StringUtils.isBlank(type)){		//第二级
				CodeExample codeExample=new CodeExample();
				codeExample.setOrderByClause("sortno desc,code asc");
				CodeExample.Criteria crit=codeExample.createCriteria();
				crit.andTypecodeEqualTo(id).andParentidEqualTo("0");
				result=codeService.selectByExample(codeExample);
				for(Code sd:result){
					TreeNode td=new TreeNode();
					td.setId(sd.getCode());
					td.setName(sd.getName());
					td.setParentid(sd.getTypecode());
					td.setAttributes(JSONObject.fromObject(sd));
					treeNode.add(td);
				}
			}
			else{		//第三级及以上
				CodeExample codeExample=new CodeExample();
				codeExample.setOrderByClause("sortno desc,code asc");
				CodeExample.Criteria crit=codeExample.createCriteria();
				crit.andParentidEqualTo(id);
				result=codeService.selectByExample(codeExample);
				for(Code sd:result){
					TreeNode td=new TreeNode();
					td.setId(sd.getCode());
					td.setName(sd.getName());
					td.setParentid(sd.getParentid());
					td.setAttributes(JSONObject.fromObject(sd));
					treeNode.add(td);
				}
			}
		}
		return ReturnJsonData.list2easyUiTreeData(treeNode, "id", "name", "parentid", "state", "", true);
	}
	
	/**
	 * 添加
	 * @param model
	 * @param type	： 不为空则是新增第三级及以上
	 * @param code
	 * @return
	 */
	@RequestMapping(value="/addDict.do")
	@ResponseBody
	public String addDict(ModelMap model,String type,Code code){
		code.setNamesimple(Pinyin4jUtil.converterToFirstSpell(code.getName()));
		code.setCreatetime(new Date());
		if(StringUtils.isNotBlank(code.getParentid())){
			if(StringUtils.isBlank(type)){	//新增第二级
				code.setTypecode(code.getParentid());
				code.setParentid(null);
				code.setCode(code.getTypecode()+codeService.getCode(code.getTypecode()));
				code.setTypename(codeService.getCodesByType(code.getTypecode()).get(0).getTypename());
			}
			else{	//新增第三级及以上
				Code parent=codeService.getCodeBycode(code.getParentid());
				code.setCode(parent.getTypecode()+codeService.getCode(parent.getTypecode()));
				code.setTypecode(parent.getTypecode());
				code.setTypename(parent.getTypename());
			}
		}
		else{		//第一级
			code.setCode(code.getTypecode()+"001");
		}
		codeService.insertSelective(code);
		return "添加成功";
	}
	
	@RequestMapping(value="/deleteCode.action")
	@ResponseBody
	public String deleteCode(String code){
		CodeExample codeExample=new CodeExample();
		codeExample.createCriteria().andCodeEqualTo(code);
		codeService.deleteByExample(codeExample);
		return "删除成功";
	}
}
