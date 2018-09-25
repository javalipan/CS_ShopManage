package com.manage.query.mapper;

import java.util.List;

import com.manage.query.model.MenuQuery;

public interface MenuQueryMapper {

	List<MenuQuery> selectMenuQuery(MenuQuery menuQuery);
	
	int countByMenuQuery(MenuQuery menuQuery);
	
	/** 
	* @Title: selectMenuPermission 
	* @Description: 根据用户查询权限列表
	* @param menuQuery
	* @return List<MenuQuery>     
	*/
	List<MenuQuery> selectMenuPermission(MenuQuery menuQuery);
}
