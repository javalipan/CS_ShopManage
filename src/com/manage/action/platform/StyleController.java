package com.manage.action.platform;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.GoodsExample;
import com.manage.dao.model.Style;
import com.manage.dao.model.StyleExample;
import com.manage.query.model.TreeNode;
import com.manage.service.IGoodsService;
import com.manage.service.IStyleService;
import com.manage.util.ReturnJsonData;

/**
 * 风格管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/style")
public class StyleController extends BaseController{
	
	@Autowired
	private IStyleService styleService;
	@Autowired
	private IGoodsService goodsService;

	@RequestMapping(value="/initStyleTree.action")
	public String initStyleTree(ModelMap model) {
		return "style/styletree";
	}
	
	/**
	 * 异步加载数据
	 * @param model
	 * @param id : 父级id，如果不传加载第一级
	 * @return
	 */
	@RequestMapping(value="/getTreeData.do")
	@ResponseBody
	public String getTreeData(ModelMap model,Long id){
		List<Style> result = null;
		List<TreeNode> treeNode=new ArrayList<TreeNode>();
		if(id==null||id==0){		//第一级
			StyleExample styleExample=new StyleExample();
			styleExample.createCriteria().andParentidIsNull();
			result=styleService.selectByExample(styleExample);
		}
		else{
			StyleExample styleExample=new StyleExample();
			styleExample.createCriteria().andParentidEqualTo(id);
			result=styleService.selectByExample(styleExample);
		}
		for(Style s:result){
			TreeNode td=new TreeNode();
			td.setId(String.valueOf(s.getId()));
			td.setName(s.getName());
			td.setParentid(String.valueOf(s.getParentid()));
			td.setAttributes(JSONObject.fromObject(s));
			treeNode.add(td);
		}
		return ReturnJsonData.list2easyUiTreeData(treeNode, "id", "name", "parentid", "state", "", true);
	}
	
	/**
	 * 添加
	 * @param model
	 * @param code
	 * @return
	 */
	@RequestMapping(value="/addStyle.do")
	@ResponseBody
	public String addStyle(ModelMap model,Style style){
		styleService.insertSelective(style);
		return "添加成功";
	}
	
	@RequestMapping(value="/deleteStyle.action")
	@ResponseBody
	public String deleteStyle(Long id){
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andStyletypeidEqualTo(id);
		int count=goodsService.countByExample(goodsExample);
		Map<String, Object> map=new HashMap<String, Object>();
		if(count>0){
			map.put("result", false);
			map.put("mes", "已有商品使用此风格，无法删除");
			return JSONObject.fromObject(map).toString();
		}
		StyleExample styleExample=new StyleExample();
		styleExample.createCriteria().andParentidEqualTo(id);
		int count2=styleService.countByExample(styleExample);
		if(count2>0){
			map.put("result", false);
			map.put("mes", "存在子风格，无法删除");
			return JSONObject.fromObject(map).toString();
		}
		styleService.deleteByPrimaryKey(id);
		map.put("result", true);
		map.put("mes", "删除成功");
		return JSONObject.fromObject(map).toString();
	}
	
	@RequestMapping(value="/searchStyleData.action")
	@ResponseBody
	public String searchStyleData(String id){
		StyleExample styleExample=new StyleExample();
		List<Style> styles=styleService.selectByExample(styleExample);
		List<TreeNode> treenodes=new ArrayList<TreeNode>();
		for(Style p:styles){
			TreeNode treeNode=new TreeNode();
			treeNode.setId(String.valueOf(p.getId()));
			treeNode.setName(p.getName());
			treeNode.setParentid(String.valueOf(p.getParentid()));
			treeNode.setChecked("false");
			treeNode.setState("open");
			treeNode.setAttributes(JSONObject.fromObject(p));
			treenodes.add(treeNode);
		}
		return super.list2easyUiTreeData(treenodes, "id", "name", "parentid", "state", "checked", true);
	}
}
