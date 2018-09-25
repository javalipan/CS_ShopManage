package com.manage.service;

import java.util.List;

import com.manage.dao.model.Menu;
import com.manage.dao.model.MenuExample;
import com.manage.query.model.MenuQuery;

public interface IMenuService {

	int countByExample(MenuExample example);

    int deleteByExample(MenuExample example);

    int deleteByPrimaryKey(String id);

    int insert(Menu record);

    List<Menu> selectByExample(MenuExample example);

    Menu selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Menu record);

    int updateByPrimaryKey(Menu record);
    
    /** 
    * @Title: delteByIds 
    * @Description: 根据id列表删除
    * @param ids    
    * @return void     
    */
    void deleteByIds(String ids);
    
    /** 
    * @Title: selectMenuQuery 
    * @Description: 根据MenuQuery查询列表
    * @param menuQuery
    * @return List<MenuQuery>     
    */
    List<MenuQuery> selectMenuQuery(MenuQuery menuQuery);
	
	/** 
	* @Title: countByMenuQuery 
	* @Description: 查询条数
	* @param menuQuery
	* @return int     
	*/
	int countByMenuQuery(MenuQuery menuQuery);
	
	/** 
	* @Title: selectMenuPermission 
	* @Description: 根据用户查询权限列表
	* @param menuQuery
	* @return List<MenuQuery>     
	*/
	List<MenuQuery> selectMenuPermission(MenuQuery menuQuery);
}
