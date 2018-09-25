package com.manage.query.mapper;

import java.util.List;

import com.manage.dao.model.User;
import com.manage.query.model.RoleQuery;

public interface RoleQueryMapper {

	public List<RoleQuery> selectRoleQuery(RoleQuery roleQuery);
	
	int countByRoleQuery(RoleQuery roleQuery);
	
	/** 
	* @Title: selectAddedUsers 
	* @Description: 查询角色已添加用户列表
	* @param roleQuery
	* @return List<User>     
	*/
	List<User> selectAddedUsers(RoleQuery roleQuery);
	
	/** 
	* @Title: countAddedUsers 
	* @Description: 查询角色已添加用户个数
	* @param roleQuery
	* @return int     
	*/
	int countAddedUsers(RoleQuery roleQuery);
	
	/** 
	* @Title: selectUnaddedUsers 
	* @Description: 查询角色未添加用户列表
	* @param roleQuery
	* @return List<User>     
	*/
	List<User> selectUnaddedUsers(RoleQuery roleQuery);
	
	/** 
	* @Title: countUnaddedUsers 
	* @Description: 查询角色未添加用户个数
	* @param roleQuery
	* @return int     
	*/
	int countUnaddedUsers(RoleQuery roleQuery);
}
