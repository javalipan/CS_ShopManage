package com.manage.service;

import java.util.List;

import com.manage.dao.model.RoleMenu;
import com.manage.dao.model.RoleMenuExample;

public interface IRoleMenuService {
	
	int countByExample(RoleMenuExample example);

    int deleteByPrimaryKey(String id);

    int insert(RoleMenu record);

    int insertSelective(RoleMenu record);

    List<RoleMenu> selectByExample(RoleMenuExample example);

    RoleMenu selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(RoleMenu record);

    int updateByPrimaryKey(RoleMenu record);
    
    /** 
    * @Title: setRolePermission 
    * @Description: 设置角色权限
    * @param roleid: 角色id
    * @param menuids： 菜单id列表
    * @return void     
    */
    void setRolePermission(String roleid,String menuids);
}
