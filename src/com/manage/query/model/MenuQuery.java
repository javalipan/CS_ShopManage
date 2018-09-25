package com.manage.query.model;

import com.manage.dao.model.Menu;
import com.manage.util.Pager;

public class MenuQuery extends Menu {

	private static final long serialVersionUID = 1L;
	/** 父菜单名称 */
	public String parentName;
	/** 分页 */
	public Pager pager;
	
	private String orderby;
	
	public String userid;

	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getOrderby() {
		return orderby;
	}

	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}
	
}
