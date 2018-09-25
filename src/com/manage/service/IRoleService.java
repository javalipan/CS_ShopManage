package com.manage.service;

import java.util.List;

import com.manage.dao.model.Role;
import com.manage.dao.model.RoleExample;
import com.manage.dao.model.User;
import com.manage.query.model.RoleQuery;

public interface IRoleService {

	int countByExample(RoleExample example);

    int insert(Role record);

    List<Role> selectByExample(RoleExample example);

    Role selectByPrimaryKey(String id);

    int updateByExample(Role record,RoleExample example);

    int updateByPrimaryKeySelective(Role record);
    
    /** 
    * @Title: deleteRoleByIds 
    * @Description: 根据id列表删除角色
    * @param ids    
    * @return void     
    */
    void deleteRoleByIds(String ids);
    
    /** 
    * @Title: selectRoleQuery 
    * @Description: 关联查询角色
    * @param roleQuery
    * @return List<RoleQuery>     
    */
    List<RoleQuery> selectRoleQuery(RoleQuery roleQuery);
    
    /** 
    * @Title: countByRoleQuery 
    * @Description: 查询条数
    * @param roleQuery
    * @return int     
    */
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
	
	/** 
	* @Title: addRoleMember 
	* @Description: 角色添加成员
	* @param roleid: 角色id
	* @param userids： 用户id列表
	* @return void     
	*/
	void addRoleMember(String roleid,String userids);
	
	/** 
	* @Title: deleteRoleMemeber 
	* @Description: 角色删除成员
	* @param roleid： 角色id
	* @param userids： 用户id列表
	* @return void     
	*/
	void deleteRoleMemeber(String roleid,String userids);

}
