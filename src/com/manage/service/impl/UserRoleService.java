package com.manage.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.UserRoleMapper;
import com.manage.dao.model.UserRoleExample;
import com.manage.service.IUserRoleService;

@Service(value="userRoleService")
public class UserRoleService implements IUserRoleService {
	
	@Autowired
	private UserRoleMapper userRoleMapper;

	public boolean existsUserInRole(String userid, String roleid) {
		UserRoleExample userRoleExample=new UserRoleExample();
		UserRoleExample.Criteria crit=userRoleExample.createCriteria();
		crit.andUseridEqualTo(userid);
		crit.andRoleidEqualTo(roleid);
		return userRoleMapper.countByExample(userRoleExample)>0;
	}

}
