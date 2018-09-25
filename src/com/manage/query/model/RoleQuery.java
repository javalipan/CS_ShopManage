package com.manage.query.model;

import com.manage.dao.model.Role;
import com.manage.util.Pager;

public class RoleQuery extends Role{

	private static final long serialVersionUID = 1L;
	
	public String typeName;
	
	public String username;
	
	Pager pager;

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

}
