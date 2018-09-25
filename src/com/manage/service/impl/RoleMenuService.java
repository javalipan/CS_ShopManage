package com.manage.service.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.RoleMenuMapper;
import com.manage.dao.model.RoleMenu;
import com.manage.dao.model.RoleMenuExample;
import com.manage.service.ILogService;
import com.manage.service.IRoleMenuService;

@Service(value="roleMenuService")
public class RoleMenuService implements IRoleMenuService{
	
	@Autowired
	private RoleMenuMapper roleMenuMapper;
	@Autowired
	private ILogService logService;

	public int countByExample(RoleMenuExample example) {
		return roleMenuMapper.countByExample(example);
	}

	public int deleteByPrimaryKey(String id) {
		int i=roleMenuMapper.deleteByPrimaryKey(id);
		if(i>0){
			logService.insertDeleteLog("删除角色权限");
		}
		return i;
	}

	public int insert(RoleMenu record) {
		int i= roleMenuMapper.insert(record);
		if(i>0){
			logService.insertAddLog("添加角色权限");
		}
		return i;
	}

	public int insertSelective(RoleMenu record) {
		int i= roleMenuMapper.insertSelective(record);
		if(i>0){
			logService.insertAddLog("添加角色权限");
		}
		return i;
	}

	public List<RoleMenu> selectByExample(RoleMenuExample example) {
		return roleMenuMapper.selectByExample(example);
	}

	public RoleMenu selectByPrimaryKey(String id) {
		return roleMenuMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKey(RoleMenu record) {
		return roleMenuMapper.updateByPrimaryKey(record);
	}

	public int updateByPrimaryKeySelective(RoleMenu record) {
		return roleMenuMapper.updateByPrimaryKeySelective(record);
	}

	public void setRolePermission(String roleid, String menuids) {
		RoleMenuExample roleMenuExample=new RoleMenuExample();
		RoleMenuExample.Criteria crit=roleMenuExample.createCriteria();
		crit.andRoleidEqualTo(roleid);
		roleMenuMapper.deleteByExample(roleMenuExample);
		String ids[]=menuids.split(",");
		for(String menuid:ids){
			RoleMenu roleMenu =new RoleMenu();
			roleMenu.setRoleid(roleid);
			roleMenu.setMenuid(menuid);
			roleMenu.setId(UUID.randomUUID().toString());
			roleMenuMapper.insert(roleMenu);
		}
	}

}
