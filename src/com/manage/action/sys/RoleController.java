package com.manage.action.sys;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Menu;
import com.manage.dao.model.MenuExample;
import com.manage.dao.model.Role;
import com.manage.dao.model.RoleMenu;
import com.manage.dao.model.RoleMenuExample;
import com.manage.dao.model.User;
import com.manage.query.model.RoleQuery;
import com.manage.service.IMenuService;
import com.manage.service.IRoleMenuService;
import com.manage.service.IRoleService;
import com.manage.util.Pager;
import com.manage.util.TreeNodes;

@Controller
@RequestMapping(value="/role")
public class RoleController extends BaseController{

	@Autowired
	private IRoleService roleService;
	@Autowired
	private IMenuService menuService;
	@Autowired
	private IRoleMenuService roleMenuService;
	
	
	@RequestMapping(value="/initRoleList.action")
	public String initRoleList(){
		return "role/rolelist";
	}
	
	@RequestMapping(value="/searchRoles.action")
	@ResponseBody
	public String searchRoles(ModelMap model,RoleQuery roleQuery,Pager pager){
		roleQuery.setPager(pager);
		int count=roleService.countByRoleQuery(roleQuery);
		List<RoleQuery> roleList=roleService.selectRoleQuery(roleQuery);
		return DataGridJson(roleList, count);
	}
	
	@RequestMapping(value="/initRoleEdit.action")
	public String initRoleEdit(ModelMap model,Role role){
		if(role!=null&&role.getId()!=null){
			role=roleService.selectByPrimaryKey(role.getId());
			model.put("role", role);
		}
		return "role/roleEdit";
	}
	
	@RequestMapping(value="/saveRole.action")
	@ResponseBody
	public String saveRole(ModelMap model,Role role){
		if(StringUtils.isEmpty(role.getId())){		//添加
			role.setId(getUUID());
			roleService.insert(role);
		}
		else{		//修改
			roleService.updateByPrimaryKeySelective(role);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteRole.action")
	@ResponseBody
	public String deleteRole(ModelMap model,String ids){
		roleService.deleteRoleByIds(ids);
		return "删除成功";
	}
	
	@RequestMapping(value="/initRoleUserList.action")
	public String initRoleUserPage(ModelMap model,String roleid){
		model.put("roleid", roleid);
		return "role/roleuserList";
	}
	
	@RequestMapping(value="/getAddedUserList.action")
	@ResponseBody
	public String getAddedUserList(ModelMap model,RoleQuery roleQuery,Pager pager){
		roleQuery.setPager(pager);
		int count=roleService.countAddedUsers(roleQuery);
		List<User> userList=roleService.selectAddedUsers(roleQuery);
		return DataGridJson(userList, count);
	}
	
	@RequestMapping(value="/initUnaddedUserPage.action")
	public String initUnaddedUserPage(ModelMap model,String roleid){
		model.put("roleid", roleid);
		return "role/unaddUserList";
	}
	
	@RequestMapping(value="/searchUnaddedUser.action")
	@ResponseBody
	public String searchUnaddedUser(ModelMap model,RoleQuery roleQuery,Pager pager){
		roleQuery.setPager(pager);
		int count=roleService.countUnaddedUsers(roleQuery);
		List<User> userList=roleService.selectUnaddedUsers(roleQuery);
		return DataGridJson(userList, count);
	}
	
	@RequestMapping(value="/addRoleMember.action")
	@ResponseBody
	public String addRoleMember(ModelMap modle,String roleid,String userids){
		roleService.addRoleMember(roleid, userids);
		return "添加成功!";
	}
	
	@RequestMapping(value="/deleteRoleMember.action")
	@ResponseBody
	public String deleteRoleMember(ModelMap modle,String roleid,String userids){
		roleService.deleteRoleMemeber(roleid, userids);
		return "删除成功!";
	}
	
	/** 
	* @Title: initSetRolePermisstion 
	* @Description: 初始化设置权限
	* @param model
	* @param roleid
	* @return String     
	*/
	@RequestMapping(value="/initSetRolePermisstion.action")
	public String initSetRolePermisstion(ModelMap model,String roleid){
		model.put("roleid", roleid);
		return "role/rolePermission";
	}
	
	@RequestMapping(value="/getMenuTree.action")
	@ResponseBody
	public String getMenuTree(ModelMap model,String roleid){
		MenuExample menuExample=new MenuExample();
		menuExample.setOrderByClause("sortby asc");
		List<Menu> menus=menuService.selectByExample(menuExample);		//所有菜单
		RoleMenuExample roleMenuExample=new RoleMenuExample();
		RoleMenuExample.Criteria crit=roleMenuExample.createCriteria();
		crit.andRoleidEqualTo(roleid);
		List<String> addMenuids=new ArrayList<String>();
		List<RoleMenu>  roleMenus=roleMenuService.selectByExample(roleMenuExample);
		for(RoleMenu roleMenu:roleMenus){
			addMenuids.add(roleMenu.getMenuid());
		}
		List<TreeNodes> treeNodes=new ArrayList<TreeNodes>();
		for(Menu menu:menus){
			TreeNodes node=new TreeNodes();
			node.setId(menu.getId());
			node.setText(menu.getName());
			node.setParentId(menu.getPid());
			if(addMenuids.contains(menu.getId())){
				node.setChecked(true);
			}
			else{
				node.setChecked(false);
			}
			treeNodes.add(node);
		}
		return JSONArray.fromObject(list2TreeNodes(treeNodes)).toString();
	}
	
	@RequestMapping(value="/setRolePermission.action")
	@ResponseBody
	public String setRolePermission(ModelMap model,String roleid,String menuids){
		roleMenuService.setRolePermission(roleid, menuids);
		return "权限设置成功!";
	}
	
}
