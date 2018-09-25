package com.manage.action.sys;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Menu;
import com.manage.dao.model.MenuExample;
import com.manage.query.model.MenuQuery;
import com.manage.service.IMenuService;
import com.manage.util.Pager;

@Controller
@RequestMapping(value="/menu")
public class MenuController extends BaseController{

	@Autowired
	private IMenuService menuService;
	
	@RequestMapping(value="/initMenuList.action")
	public String initMenuList(){
		return "menu/menulist";
	}
	
	@RequestMapping(value="/searchMenus.action")
	@ResponseBody
	public String searchMenus(ModelMap model,MenuQuery menuQuery,Pager pager){
		menuQuery.setPager(pager);
		menuQuery.setOrderby("sortby asc");
		int count=menuService.countByMenuQuery(menuQuery);
		List<MenuQuery> menuList=menuService.selectMenuQuery(menuQuery);
		return DataGridJson(menuList, count);
	}
	
	@RequestMapping(value="/initMenuEdit.action")
	public String initMenuEdit(ModelMap model,Menu menu){
		MenuExample menuExample=new MenuExample();
		menuExample.setOrderByClause("sortby asc");
		MenuExample.Criteria crit=menuExample.createCriteria();
		crit.andPidEqualTo("0");
		List<Menu> parents=menuService.selectByExample(menuExample);
		model.put("parents", parents);
		if(menu!=null&&menu.getId()!=null){
			menu=menuService.selectByPrimaryKey(menu.getId());
			model.put("menu", menu);
		}
		return "menu/menuEdit";
	}
	
	@RequestMapping(value="/saveMenu.action")
	@ResponseBody
	public String saveMenu(ModelMap model,Menu menu){
		if(StringUtils.isEmpty(menu.getPid())){
			menu.setPid("0");
		}
		if(StringUtils.isEmpty(menu.getId())){		//添加
			menu.setId(getUUID());
			menuService.insert(menu);
		}
		else{		//修改
			menuService.updateByPrimaryKeySelective(menu);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteMenu.action")
	@ResponseBody
	public String deleteMenu(ModelMap model,String ids){
		menuService.deleteByIds(ids);
		return "删除成功";
	}
	
}
