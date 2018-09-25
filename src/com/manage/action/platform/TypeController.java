package com.manage.action.platform;

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
import com.manage.dao.model.GoodsExample;
import com.manage.dao.model.Type;
import com.manage.dao.model.TypeExample;
import com.manage.query.model.TreeNode;
import com.manage.service.IGoodsService;
import com.manage.service.ITypeService;

/**
 * 商品分类管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/type")
public class TypeController extends BaseController{
	
	@Autowired
	private ITypeService typeService;
	@Autowired
	private IGoodsService goodsService;

	@RequestMapping(value="/initTypeList.action")
	public String initTypeList(){
		return "type/typeList";
	}
	
	@RequestMapping(value="/searchTypeData.action")
	@ResponseBody
	public String searchTypeData(String id){
		TypeExample typeExample=new TypeExample();
		typeExample.setOrderByClause("sortno asc");
		List<Type> types=typeService.selectByExample(typeExample); 
		List<TreeNode> treenodes=new ArrayList<TreeNode>();
		for(Type p:types){
			TreeNode treeNode=new TreeNode();
			treeNode.setId(p.getCode());
			treeNode.setName(p.getName());
			treeNode.setParentid(p.getParentcode());
			treeNode.setChecked("false");
			treeNode.setState("open");
			treeNode.setAttributes(JSONObject.fromObject(p));
			treenodes.add(treeNode);
		}
		return super.list2easyUiTreeData(treenodes, "id", "name", "parentid", "state", "checked", true);
	}
	
	@RequestMapping(value="/initTypeEdit.action")
	public String initTypeEdit(ModelMap model,Type type){
		if(type!=null&&type.getId()!=null){
			type=typeService.selectByPrimaryKey(type.getId());
			model.put("type", type);
		}
		return "type/typeEdit";
	}
	
	@RequestMapping(value="/saveType.action")
	@ResponseBody
	public String saveType(ModelMap model,Type type){
		if(StringUtils.isBlank(type.getParentcode())){
			type.setLongcode(type.getCode());
		}
		else{
			Type p=typeService.selectByCode(type.getParentcode());
			type.setLongcode(p.getLongcode()+"-"+type.getCode());
		}
		if(type.getId()==null){		//添加
			type.setCreatetime(new Date());
			type.setUpdatetime(new Date());
			typeService.insertSelective(type);
		}
		else{		//修改
			type.setUpdatetime(new Date());
			typeService.updateByPrimaryKeySelective(type);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteType.action")
	@ResponseBody
	public String deleteType(Long id){
		if(id==null){
			return "删除失败";
		}
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andTypeidEqualTo(id);
		if(goodsService.countByExample(goodsExample)>0){
			return "该分类下有商品,不能删除";
		}
		typeService.deleteByPrimaryKey(id);
		return "删除成功";
	}
	
	@RequestMapping(value="/codeExists.action")
	@ResponseBody
	public String codeExists(String code,Long id){
		TypeExample typeExample=new TypeExample();
		TypeExample.Criteria crit=typeExample.createCriteria();
		if(id!=null&&id>0){
			crit.andIdNotEqualTo(id);
		}
		crit.andCodeEqualTo(code);
		if(typeService.countByExample(typeExample)>0){
			return "true";
		}
		return "false";
	}
}
