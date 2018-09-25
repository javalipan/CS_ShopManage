package com.manage.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.MenuMapper;
import com.manage.dao.model.Menu;
import com.manage.dao.model.MenuExample;
import com.manage.query.mapper.MenuQueryMapper;
import com.manage.query.model.MenuQuery;
import com.manage.service.ILogService;
import com.manage.service.IMenuService;

@Service(value="menuService")
public class MenuService implements IMenuService {
	
	@Autowired
	private MenuMapper menuMapper;
	@Autowired
	private MenuQueryMapper menuQueryMapper;
	@Autowired
	private ILogService logService;

	public int countByExample(MenuExample example) {
		return menuMapper.countByExample(example);
	}

	public int countByMenuQuery(MenuQuery menuQuery) {
		return menuQueryMapper.countByMenuQuery(menuQuery);
	}

	public int deleteByExample(MenuExample example) {
		return menuMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(String id) {
		return menuMapper.deleteByPrimaryKey(id);
	}

	public void deleteByIds(String ids) {
		String strs[]=ids.split(",");
		List<String> idlist=new ArrayList<String>();
		for(String str:strs){
			idlist.add(str);
		}
		MenuExample menuExample=new MenuExample();
		MenuExample.Criteria crit=menuExample.createCriteria();
		crit.andIdIn(idlist);
		logService.insertDeleteLog("删除菜单:"+ids);
		menuMapper.deleteByExample(menuExample);
	}

	public int insert(Menu record) {
		int i=menuMapper.insert(record);
		logService.insertDeleteLog("添加菜单:"+record.getName());
		return i;
	}

	public List<Menu> selectByExample(MenuExample example) {
		return menuMapper.selectByExample(example);
	}

	public Menu selectByPrimaryKey(String id) {
		return menuMapper.selectByPrimaryKey(id);
	}

	public List<MenuQuery> selectMenuQuery(MenuQuery menuQuery) {
		return menuQueryMapper.selectMenuQuery(menuQuery);
	}

	public int updateByPrimaryKey(Menu record) {
		int i=menuMapper.updateByPrimaryKey(record);
		if(i>0){
			logService.insertUpdateLog("修改菜单:"+record.getName());
		}
		return i;
	}

	public int updateByPrimaryKeySelective(Menu record) {
		int i=menuMapper.updateByPrimaryKeySelective(record);
		if(i>0){
			logService.insertUpdateLog("修改菜单:"+record.getName());
		}
		return i;
	}

	public List<MenuQuery> selectMenuPermission(MenuQuery menuQuery) {
		return menuQueryMapper.selectMenuPermission(menuQuery);
	}

}
