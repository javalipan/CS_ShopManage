package com.manage.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.RoleMapper;
import com.manage.dao.mapper.UserRoleMapper;
import com.manage.dao.model.Role;
import com.manage.dao.model.RoleExample;
import com.manage.dao.model.User;
import com.manage.dao.model.UserRole;
import com.manage.dao.model.UserRoleExample;
import com.manage.query.mapper.RoleQueryMapper;
import com.manage.query.model.RoleQuery;
import com.manage.service.ILogService;
import com.manage.service.IRoleService;

@Service(value="roleService")
public class RoleService implements IRoleService {
	
	@Autowired
	private RoleMapper roleMapper;
	@Autowired
	private RoleQueryMapper roleQueryMapper;
	@Autowired
	private UserRoleMapper userRoleMapper;
	@Autowired
	private ILogService logService;

	public int countByExample(RoleExample example) {
		return roleMapper.countByExample(example);
	}

	public void deleteRoleByIds(String ids) {
		String strs[]=ids.split(",");
		List<String> idlist=new ArrayList<String>();
		for(String str:strs){
			idlist.add(str);
		}
		RoleExample roleExample =new RoleExample();
		RoleExample.Criteria criteria=roleExample.createCriteria();
		criteria.andIdIn(idlist);
		roleMapper.deleteByExample(roleExample);
		logService.insertDeleteLog("删除角色列表:"+ids);
	}

	public int insert(Role record) {
		int i=roleMapper.insert(record);
		if(i>0){
			logService.insertAddLog("添加角色"+record.getName());
		}
		return i;
	}

	public List<Role> selectByExample(RoleExample example) {
		return roleMapper.selectByExample(example);
	}

	public Role selectByPrimaryKey(String id) {
		return roleMapper.selectByPrimaryKey(id);
	}

	public int updateByExample(Role record, RoleExample example) {
		int i=roleMapper.updateByExample(record, example);
		if(i>0){
			logService.insertAddLog("修改角色");
		}
		return i;
	}

	public int updateByPrimaryKeySelective(Role record) {
		int i=roleMapper.updateByPrimaryKeySelective(record);
		if(i>0){
			logService.insertAddLog("修改角色:"+record.getName());
		}
		return i;
	}

	public List<RoleQuery> selectRoleQuery(RoleQuery roleQuery) {
		return roleQueryMapper.selectRoleQuery(roleQuery);
	}

	public int countByRoleQuery(RoleQuery roleQuery) {
		return roleQueryMapper.countByRoleQuery(roleQuery);
	}

	public int countAddedUsers(RoleQuery roleQuery) {
		return roleQueryMapper.countAddedUsers(roleQuery);
	}

	public int countUnaddedUsers(RoleQuery roleQuery) {
		return roleQueryMapper.countUnaddedUsers(roleQuery);
	}

	public List<User> selectAddedUsers(RoleQuery roleQuery) {
		return roleQueryMapper.selectAddedUsers(roleQuery);
	}

	public List<User> selectUnaddedUsers(RoleQuery roleQuery) {
		return roleQueryMapper.selectUnaddedUsers(roleQuery);
	}

	public void addRoleMember(String roleid, String userids) {
		String[] ids=userids.split(",");
		for(String userid: ids){
			UserRole userRole=new UserRole();
			userRole.setId(UUID.randomUUID().toString());
			userRole.setUserid(userid);
			userRole.setRoleid(roleid);
			userRoleMapper.insert(userRole);
		}
		logService.insertAddLog("为角色"+roleid+"添加成员："+userids);
	}

	public void deleteRoleMemeber(String roleid, String userids) {
		String[] ids=userids.split(",");
		List<String> idarray=new ArrayList<String>();
		for(String userid: ids){
			idarray.add(userid);
		}
		UserRoleExample userRoleExample=new UserRoleExample();
		UserRoleExample.Criteria crit=userRoleExample.createCriteria();
		crit.andRoleidEqualTo(roleid);
		crit.andUseridIn(idarray);
		userRoleMapper.deleteByExample(userRoleExample);
		logService.insertDeleteLog("角色"+roleid+"删除成员："+userids);
	}

}
